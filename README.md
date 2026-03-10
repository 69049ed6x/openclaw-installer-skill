# openclaw-installer-skill

A reusable **OpenClaw Skill** that documents how to install and deploy OpenClaw across platforms (Windows/macOS/Linux/Raspberry Pi/VPS/Docker) with troubleshooting notes.

## Quick start (one command)

### Windows
```powershell
cd .\openclaw-installer
.\scripts\bootstrap-openclaw.ps1
```

### macOS / Linux / WSL2
```bash
cd ./openclaw-installer
bash ./scripts/bootstrap-openclaw.sh
```

### Feishu (optional)
```powershell
cd .\openclaw-installer
.\scripts\setup-feishu.ps1
```

## What’s inside

- `openclaw-installer/` — the skill folder
  - `SKILL.md` — main entry
  - `docs/` — platform-specific guides
  - `docker/` — docker-compose + Dockerfile templates
  - `tests/` — basic + docker test scripts
  - `scripts/` — user-info collection scripts (non-sensitive)

## Sources

This skill is continuously aligned with official OpenClaw documentation (see links embedded in the docs files and SKILL.md).

## License

MIT
