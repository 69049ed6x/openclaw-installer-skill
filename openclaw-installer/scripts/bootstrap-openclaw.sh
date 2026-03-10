#!/usr/bin/env bash
# Bootstrap OpenClaw (macOS/Linux/WSL2)
# Sources:
# - https://docs.openclaw.ai/install
# - https://docs.openclaw.ai/install/node
#
# Security: never hardcode tokens in this repo.

set -euo pipefail

DRY_RUN=false
SKIP_DOCKER_PROMPT=false

OPEN_DASHBOARD=false
PLUGINS="${OPENCLAW_PLUGINS:-}"

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --skip-docker-prompt) SKIP_DOCKER_PROMPT=true ;;
    --open-dashboard) OPEN_DASHBOARD=true ;;
    --plugins=*) PLUGINS="${arg#*=}" ;;
  esac
done


yesno() {
  local prompt="$1"; local def="$2"; local ans
  read -r -p "$prompt [$def] " ans || true
  if [[ -z "$ans" ]]; then ans="$def"; fi
  [[ "$ans" =~ ^[Yy]$ ]]
}

echo "=== OpenClaw Bootstrap (macOS/Linux/WSL2) ==="

if ! $SKIP_DOCKER_PROMPT && yesno "Do you want to use Docker for OpenClaw?" "n"; then
  echo "Docker chosen. Follow: openclaw-installer/docs/docker.md" >&2
fi

if $DRY_RUN; then
  echo "[DryRun] Would check Node 22+, install OpenClaw, write config, restart gateway."
  exit 0
fi

# Node 22+ check
if ! command -v node >/dev/null 2>&1; then
  echo "Node not found. Install Node 22+ first: https://docs.openclaw.ai/install/node" >&2
  exit 1
fi
major=$(node -v | sed -E 's/^v([0-9]+).*/\1/')
if [[ "$major" -lt 22 ]]; then
  echo "Node $major detected, but OpenClaw requires Node 22+. See: https://docs.openclaw.ai/install/node" >&2
  exit 1
fi

# Install OpenClaw via official installer script
if ! command -v openclaw >/dev/null 2>&1; then
  echo "Installing OpenClaw via official installer script..."
  curl -fsSL https://openclaw.ai/install.sh | bash
fi

echo
echo "=== Provider config ==="
apiKey="${OPENCLAW_API_KEY:-}"
baseUrl="${OPENCLAW_BASE_URL:-}"

if [[ -z "$apiKey" ]]; then
  read -r -p "Enter your provider API key: " apiKey
fi
if [[ -z "$baseUrl" ]]; then
  read -r -p "Enter API base URL (optional): " baseUrl
fi

openclaw config set env.vars.OPENAI_API_KEY "$apiKey" >/dev/null
if [[ -n "$baseUrl" ]]; then
  openclaw config set env.vars.OPENAI_BASE_URL "$baseUrl" >/dev/null
fi

# Optional plugin installs (comma-separated)
if [[ -n "$PLUGINS" ]]; then
  IFS=',' read -r -a plist <<< "$PLUGINS"
  echo "Installing plugins: $PLUGINS" >&2
  for p in "${plist[@]}"; do
    p_trim=$(echo "$p" | xargs)
    [[ -z "$p_trim" ]] && continue
    openclaw plugins install "$p_trim" >/dev/null 2>&1 || echo "Plugin install failed: $p_trim" >&2
  done
fi

openclaw gateway restart >/dev/null 2>&1 || true
openclaw status
openclaw doctor

echo
echo "Open dashboard UI: openclaw dashboard"
if $OPEN_DASHBOARD; then
  # Best effort open. Works on macOS with `open`, Linux with `xdg-open`.
  if command -v open >/dev/null 2>&1; then
    open "http://127.0.0.1:18789/" || true
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "http://127.0.0.1:18789/" || true
  fi
fi
