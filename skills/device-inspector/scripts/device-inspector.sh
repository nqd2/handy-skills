#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME=""
ADD_ITEMS=""
OUTPUT_FILE=""

usage() {
  cat <<'EOF'
Usage: bash scripts/device-inspector.sh [options]

Options:
  --project <name>   Add project context section label
  --add "<items>"    Comma-separated extra checks to run
  --output <path>    Output file path (default: <workspace-root>/device-specs.md)
  --help             Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      PROJECT_NAME="${2:-}"
      shift 2
      ;;
    --add)
      ADD_ITEMS="${2:-}"
      shift 2
      ;;
    --output)
      OUTPUT_FILE="${2:-}"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "$OUTPUT_FILE" ]]; then
  if git_root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
    OUTPUT_FILE="${git_root}/device-specs.md"
  else
    OUTPUT_FILE="${PWD}/device-specs.md"
  fi
fi

detect_os() {
  if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
    echo "WSL (Windows)"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macOS"
  else
    echo "Unknown"
  fi
}

OS_TYPE="$(detect_os)"

safe_cmd() {
  if command -v "$1" >/dev/null 2>&1; then
    shift
    "$@"
  else
    return 1
  fi
}

line_os() {
  case "$OS_TYPE" in
    Linux|WSL\ \(Windows\))
      if [[ -r /etc/os-release ]]; then
        local pretty
        pretty="$(awk -F= '/^PRETTY_NAME=/{gsub(/"/, "", $2); print $2}' /etc/os-release)"
        echo "${pretty:-$OS_TYPE} ($(uname -r), $(uname -m))"
      else
        echo "$OS_TYPE ($(uname -r), $(uname -m))"
      fi
      ;;
    macOS)
      echo "$(sw_vers -productName) $(sw_vers -productVersion) ($(uname -r), $(uname -m))"
      ;;
    *)
      echo "$OS_TYPE"
      ;;
  esac
}

line_cpu() {
  case "$OS_TYPE" in
    Linux|WSL\ \(Windows\))
      local model cores maxmhz
      model="$(lscpu | awk -F: '/Model name/{gsub(/^ +| +$/, "", $2); print $2; exit}')"
      cores="$(nproc)"
      maxmhz="$(lscpu | awk -F: '/CPU max MHz/{gsub(/^ +| +$/, "", $2); print $2; exit}')"
      if [[ -n "$maxmhz" ]]; then
        echo "${model:-Unknown CPU} | Cores: ${cores:-unknown} | Max MHz: ${maxmhz}"
      else
        echo "${model:-Unknown CPU} | Cores: ${cores:-unknown}"
      fi
      ;;
    macOS)
      echo "$(sysctl -n machdep.cpu.brand_string) | Cores: $(sysctl -n hw.ncpu)"
      ;;
    *)
      echo "Unknown"
      ;;
  esac
}

line_gpu() {
  case "$OS_TYPE" in
    Linux|WSL\ \(Windows\))
      if command -v nvidia-smi >/dev/null 2>&1; then
        local names mems
        names="$(nvidia-smi --query-gpu=name --format=csv,noheader | paste -sd ', ' -)"
        mems="$(nvidia-smi --query-gpu=memory.total --format=csv,noheader | paste -sd ', ' -)"
        echo "${names:-Unknown GPU} | VRAM: ${mems:-Unknown}"
      else
        local gpu
        gpu="$(lspci 2>/dev/null | awk -F: '/VGA|3D|Display/{print $3; exit}' | xargs)"
        echo "${gpu:-Integrated/None detected}"
      fi
      ;;
    macOS)
      local chipset vram
      chipset="$(system_profiler SPDisplaysDataType | awk -F: '/Chipset Model/{gsub(/^ +| +$/, "", $2); print $2; exit}')"
      vram="$(system_profiler SPDisplaysDataType | awk -F: '/VRAM/{gsub(/^ +| +$/, "", $2); print $2; exit}')"
      if [[ -n "$vram" ]]; then
        echo "${chipset:-Unknown GPU} | VRAM: $vram"
      else
        echo "${chipset:-Unknown GPU}"
      fi
      ;;
    *)
      echo "Unknown"
      ;;
  esac
}

line_ram() {
  case "$OS_TYPE" in
    Linux|WSL\ \(Windows\))
      free -h | awk '/^Mem:/{print $2 " total"}'
      ;;
    macOS)
      awk "BEGIN {printf \"%.1f GB total\", $(sysctl -n hw.memsize)/1024/1024/1024}"
      ;;
    *)
      echo "Unknown"
      ;;
  esac
}

write_storage() {
  case "$OS_TYPE" in
    Linux|WSL\ \(Windows\))
      echo "**Storage Devices**:"
      if command -v lsblk >/dev/null 2>&1; then
        local devices
        devices="$(lsblk -d -o NAME,SIZE,TYPE,MODEL | awk 'NR>1 && $3=="disk"{printf "  - %s %s (%s)\n", $1, $2, substr($0, index($0,$4))}')"
        if [[ -n "$devices" ]]; then
          echo "$devices"
        else
          echo "  - No block devices detected"
        fi
      else
        echo "  - lsblk not available"
      fi
      echo "- **Root Filesystem**: $(df -h / | awk 'NR==2{print $2 " total, " $4 " free (" $5 " used)"}')"
      ;;
    macOS)
      echo "**Storage**: $(df -h / | awk 'NR==2{print $2 " total, " $4 " free (" $5 " used)"}')"
      ;;
    *)
      echo "**Storage**: Unknown"
      ;;
  esac
}

line_network() {
  if command -v ip >/dev/null 2>&1; then
    ip -brief addr show up | awk '{addr=$3; if (addr=="") addr="(no address)"; entries[++n]=$1 ": " addr} END {for (i=1; i<=n; i++) printf "%s%s", entries[i], (i<n ? "; " : "")}'
  elif command -v ifconfig >/dev/null 2>&1; then
    ifconfig | awk '/^[a-z]/{iface=$1} /status: active/{entries[++n]=iface} END {for (i=1; i<=n; i++) printf "%s%s", entries[i], (i<n ? "; " : "")}'
  else
    echo "Unknown"
  fi
}

line_uptime_load() {
  if uptime -p >/dev/null 2>&1; then
    echo "$(uptime -p); load: $(uptime | awk -F'load average: ' '{print $2}')"
  else
    uptime
  fi
}

section_project_specs() {
  echo "## Project-Specific Specifications"
  if [[ -n "$PROJECT_NAME" ]]; then
    echo "- Project: $PROJECT_NAME"
    if [[ -f "project-specs.yaml" ]]; then
      echo "- Loaded from project-specs.yaml:"
      awk '{print "  " $0}' project-specs.yaml
    else
      echo "- No project-specs.yaml found in current directory."
    fi
  else
    echo "- None provided (use --project \"name\")."
  fi
}

emit_known_extra() {
  local item="$1"
  local key
  key="$(echo "$item" | tr '[:upper:]' '[:lower:]' | xargs)"
  case "$key" in
    *cuda*)
      if command -v nvcc >/dev/null 2>&1; then
        echo "- $item: $(nvcc --version | awk -F', ' '/release/{print $2; exit}')"
      elif command -v nvidia-smi >/dev/null 2>&1; then
        echo "- $item: $(nvidia-smi | sed -n 's/.*CUDA Version: \([0-9.]\+\).*/\1/p' | head -n 1)"
      else
        echo "- $item: Not detected"
      fi
      ;;
    *docker*)
      if command -v docker >/dev/null 2>&1; then
        echo "- $item: $(docker --version)"
      else
        echo "- $item: Not installed"
      fi
      ;;
    *podman*)
      if command -v podman >/dev/null 2>&1; then
        echo "- $item: $(podman --version)"
      else
        echo "- $item: Not installed"
      fi
      ;;
    *python*)
      if command -v python3 >/dev/null 2>&1; then
        echo "- $item: $(python3 --version)"
      elif command -v python >/dev/null 2>&1; then
        echo "- $item: $(python --version)"
      else
        echo "- $item: Not installed"
      fi
      ;;
    *node*)
      if command -v node >/dev/null 2>&1; then
        echo "- $item: $(node --version)"
      else
        echo "- $item: Not installed"
      fi
      ;;
    *java*)
      if command -v java >/dev/null 2>&1; then
        echo "- $item: $(java -version 2>&1 | awk 'NR==1{print $0}')"
      else
        echo "- $item: Not installed"
      fi
      ;;
    *)
      echo "- $item: (requested; no built-in probe yet)"
      ;;
  esac
}

section_user_added() {
  echo "## User-Added Specifications"
  if [[ -z "$ADD_ITEMS" ]]; then
    echo "- None (use --add \"item1,item2\")."
    return
  fi
  IFS=',' read -r -a extras <<< "$ADD_ITEMS"
  local item
  for item in "${extras[@]}"; do
    emit_known_extra "$item"
  done
}

mkdir -p "$(dirname "$OUTPUT_FILE")"

{
  echo "# Device Specifications"
  echo
  echo "## Default Device Specifications"
  echo "- **OS**: $(line_os)"
  echo "- **CPU**: $(line_cpu)"
  echo "- **GPU + VRAM**: $(line_gpu)"
  echo "- **System RAM**: $(line_ram)"
  echo "- $(write_storage | awk 'NR==1{printf "%s", $0; next} {printf "\n  %s", $0}')"
  echo "- **Network**: $(line_network)"
  echo "- **Architecture**: $(uname -m)"
  echo "- **Uptime & Load**: $(line_uptime_load)"
  echo
  section_project_specs
  echo
  section_user_added
  echo
  echo "Last updated: $(date -Is)"
} > "$OUTPUT_FILE"

echo "device-specs written to: $OUTPUT_FILE"
