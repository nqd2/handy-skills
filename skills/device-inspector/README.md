# device-inspector

`device-inspector` is an Agent Skill compatible with the open `SKILL.md` format used by skills.sh-compatible ecosystems.

It provides:
- A standard workflow for collecting machine capabilities.
- A bundled script to generate/update a single `device-specs.md` file.
- A rule to read `device-specs.md` before hardware-dependent decisions.

## Structure

```text
device-inspector/
├── SKILL.md
├── scripts/
│   └── device-inspector.sh
└── README.md
```

## Usage

From the skill folder:

```bash
chmod +x scripts/device-inspector.sh
bash scripts/device-inspector.sh
```

Optional flags:

```bash
bash scripts/device-inspector.sh --project "my-ml-project"
bash scripts/device-inspector.sh --add "CUDA version,Docker version,Python packages"
bash scripts/device-inspector.sh --output /path/to/device-specs.md
```

By default, output is written to `<workspace-root>/device-specs.md` when inside a git repo; otherwise it falls back to `./device-specs.md`.
