#!/usr/bin/env bash
# collect-user-info.sh
# Purpose: Collect non-sensitive troubleshooting info for OpenClaw + OpenCode.
# Safety: Do NOT collect personal content (chat messages, documents, tokens, API keys).
# Consent: Run only with user consent.

set -euo pipefail

TS=$(date +%Y%m%d-%H%M%S)
OUT="$HOME/openclaw-user-info-$TS.txt"

{
  echo "=== OpenClaw/OpenCode Diagnostic Info ==="
  echo "CollectedAt: $(date -Is)"
  echo

  echo "== OS =="
  uname -a || true
  if [ -f /etc/os-release ]; then
    cat /etc/os-release | sed -n 's/^PRETTY_NAME=//p' | tr -d '"' | sed 's/^/LinuxDistro: /'
  fi
  echo

  echo "== Versions =="
  command -v openclaw >/dev/null 2>&1 && echo "OpenClaw: $(openclaw --version)" || echo "OpenClaw: NOT_FOUND"
  command -v opencode >/dev/null 2>&1 && echo "OpenCode: $(opencode --version)" || echo "OpenCode: NOT_FOUND"
  command -v node >/dev/null 2>&1 && echo "Node: $(node --version)" || echo "Node: NOT_FOUND"
  command -v npm >/dev/null 2>&1 && echo "npm: $(npm --version)" || echo "npm: NOT_FOUND"
  command -v docker >/dev/null 2>&1 && echo "Docker: $(docker --version)" || echo "Docker: NOT_FOUND"
  echo

  echo "== OpenClaw Status (redacted) =="
  if command -v openclaw >/dev/null 2>&1; then
    openclaw status || true
  fi
  echo

  echo "== OpenCode Models (optional) =="
  if command -v opencode >/dev/null 2>&1; then
    opencode models | head -n 200 || true
  fi
  echo

  echo "== Notes =="
  echo "- No secrets collected."
  echo "- Review this file before sharing it."
} > "$OUT"

echo "Saved: $OUT"