#!/usr/bin/env bash
# Bootstrap OpenClaw (macOS/Linux/WSL2)
# Sources:
# - https://docs.openclaw.ai/install
# - https://docs.openclaw.ai/install/node
#
# Security: never hardcode tokens in this repo.

set -euo pipefail

yesno() {
  local prompt="$1"; local def="$2"; local ans
  read -r -p "$prompt [$def] " ans || true
  if [[ -z "$ans" ]]; then ans="$def"; fi
  [[ "$ans" =~ ^[Yy]$ ]]
}

echo "=== OpenClaw Bootstrap (macOS/Linux/WSL2) ==="

if yesno "Do you want to use Docker for OpenClaw?" "n"; then
  echo "Docker chosen. Follow: openclaw-installer/docs/docker.md" >&2
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
read -r -p "Enter your provider API key: " apiKey
read -r -p "Enter API base URL (optional): " baseUrl

openclaw config set env.vars.OPENAI_API_KEY "$apiKey" >/dev/null
if [[ -n "$baseUrl" ]]; then
  openclaw config set env.vars.OPENAI_BASE_URL "$baseUrl" >/dev/null
fi

openclaw gateway restart >/dev/null 2>&1 || true
openclaw status
openclaw doctor

echo
echo "Open dashboard UI: openclaw dashboard"
