---
name: device-inspector
description: |
  Inspects the current device's hardware and system specs by running shell commands and generates or updates device-specs.md.
  Use when hardware awareness is needed before performance, installation, optimization, resource-limit, or feasibility decisions.
  Always read device-specs.md first before hardware-dependent reasoning.
  Supports default specs, project-specific additions, and user-requested checks.
---

# Device Inspector

## Core Rule
Before any decision that depends on hardware, storage, GPU, RAM, or performance:
1. Check whether `device-specs.md` exists.
2. If it is missing or older than 24 hours, run the inspection script.
3. Read all of `device-specs.md` before continuing.

## Agent Workflow
1. Run `bash scripts/device-inspector.sh` from this skill folder.
2. The script detects platform and collects default device specs.
3. The script writes a single Markdown report file (`device-specs.md`) in the current project root by default.
4. Read the report and use explicit values (CPU cores, RAM, GPU/VRAM, storage, etc.) in any hardware-dependent recommendation.

## Script Usage
- Default: `bash scripts/device-inspector.sh`
- Custom output: `bash scripts/device-inspector.sh --output /path/to/device-specs.md`
- Project context: `bash scripts/device-inspector.sh --project "my-ml-project"`
- User additions: `bash scripts/device-inspector.sh --add "CUDA version,Docker version,Python packages"`
- Combine options: `bash scripts/device-inspector.sh --project "my-ml-project" --add "Node.js version" --output ./device-specs.md`

## Default Report Sections
`device-specs.md` includes:

### Default Device Specifications
- OS details (name/version/kernel/arch)
- CPU model and core count
- GPU and VRAM when detectable
- RAM total
- Storage devices and root filesystem usage
- Active network interfaces
- Architecture
- Uptime and load

### Project-Specific Specifications
- Added when `--project` is provided.
- Can include requirements loaded from `project-specs.yaml` when present.

### User-Added Specifications
- Populated by values passed to `--add`.
- Script attempts common checks for known items and records unknown items as placeholders.

## Trigger Conditions
Use this skill when prompts mention:
- hardware, device, machine, specs
- GPU, VRAM, CUDA, RAM, memory
- can it run, requirements, performance
- install feasibility, model sizing, acceleration

Also run at project start when system capabilities are likely to affect technical choices.
