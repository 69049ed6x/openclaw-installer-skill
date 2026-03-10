# collect-user-info.ps1
# Purpose: Collect non-sensitive troubleshooting info for OpenClaw + OpenCode.
# Safety: Do NOT collect personal content (chat messages, documents, tokens, API keys).
# Consent: Run only with user consent.

$ErrorActionPreference = "SilentlyContinue"

$ts = Get-Date -Format "yyyyMMdd-HHmmss"
$out = Join-Path $env:USERPROFILE "openclaw-user-info-$ts.txt"

function Write-Line($s) {
  Add-Content -Path $out -Value $s
}

"=== OpenClaw/OpenCode Diagnostic Info ===" | Out-File -FilePath $out -Encoding utf8
Write-Line ("CollectedAt: " + (Get-Date).ToString("s"))
Write-Line ""

Write-Line "== OS =="
Write-Line ("WindowsVersion: " + (Get-ComputerInfo | Select-Object -ExpandProperty WindowsVersion))
Write-Line ("WindowsBuildLabEx: " + (Get-ComputerInfo | Select-Object -ExpandProperty WindowsBuildLabEx))
Write-Line ""

Write-Line "== Versions =="
if (Get-Command openclaw -ErrorAction SilentlyContinue) { Write-Line ("OpenClaw: " + (& openclaw --version)) } else { Write-Line "OpenClaw: NOT_FOUND" }
if (Get-Command opencode -ErrorAction SilentlyContinue) { Write-Line ("OpenCode: " + (& opencode --version)) } else { Write-Line "OpenCode: NOT_FOUND" }
if (Get-Command node -ErrorAction SilentlyContinue) { Write-Line ("Node: " + (& node --version)) } else { Write-Line "Node: NOT_FOUND" }
if (Get-Command npm -ErrorAction SilentlyContinue) { Write-Line ("npm: " + (& npm --version)) } else { Write-Line "npm: NOT_FOUND" }
if (Get-Command docker -ErrorAction SilentlyContinue) { Write-Line ("Docker: " + (& docker --version)) } else { Write-Line "Docker: NOT_FOUND" }
Write-Line ""

Write-Line "== OpenClaw Status (redacted) =="
if (Get-Command openclaw -ErrorAction SilentlyContinue) {
  # Avoid printing full config; status is enough.
  Write-Line (& openclaw status | Out-String)
}
Write-Line ""

Write-Line "== OpenCode Models (optional) =="
if (Get-Command opencode -ErrorAction SilentlyContinue) {
  Write-Line (& opencode models | Select-Object -First 200 | Out-String)
}
Write-Line ""

Write-Line "== Notes =="
Write-Line "- No secrets collected."
Write-Line "- If you need to share, review the file first and remove anything you dislike."

Write-Output "Saved: $out"