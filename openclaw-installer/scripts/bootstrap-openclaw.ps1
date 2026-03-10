<#
Bootstrap OpenClaw (Windows) — one-shot setup helper

Does:
- Optional: ask whether you plan to use Docker (docs only)
- Check Node 22+ and install via winget if missing
- Install OpenClaw using official installer script
- Ask for API key + optional base URL, then write into OpenClaw config via `openclaw config set env.vars.*`
- Restart gateway + run status/doctor

Sources (commands):
- https://docs.openclaw.ai/install
- https://docs.openclaw.ai/install/node

Security:
- Never hardcode tokens in this repo.
#>

$ErrorActionPreference = 'Stop'

function Prompt-YesNo([string]$q, [bool]$default=$true) {
  $d = if($default){'Y/n'} else {'y/N'}
  $ans = Read-Host "$q [$d]"
  if([string]::IsNullOrWhiteSpace($ans)) { return $default }
  return $ans.Trim().ToLower() -in @('y','yes')
}

Write-Host "=== OpenClaw Bootstrap (Windows) ==="

$useDocker = Prompt-YesNo "Do you want to use Docker for OpenClaw?" $false
if($useDocker){
  Write-Host "Docker chosen. Follow: openclaw-installer/docs/docker.md" -ForegroundColor Yellow
}

# Node 22+ check
$nodeOk = $false
try {
  $v = (& node -v) 2>$null
  if($v -match '^v(\d+)'){
    if([int]$Matches[1] -ge 22){ $nodeOk = $true }
  }
} catch {}

if(-not $nodeOk){
  Write-Host "Node.js 22+ not detected. Installing Node LTS via winget..." -ForegroundColor Yellow
  & winget install OpenJS.NodeJS.LTS
}

# Refresh PATH in current session
$env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User')

# Install OpenClaw (official installer script)
$openclawOk = $false
try { & openclaw --version | Out-Null; $openclawOk = $true } catch {}

if(-not $openclawOk){
  Write-Host "Installing OpenClaw via official installer script..." -ForegroundColor Yellow
  iwr -useb https://openclaw.ai/install.ps1 | iex
}

Write-Host "\n=== Provider config ==="
$apiKey = Read-Host "Enter your provider API key"
$baseUrl = Read-Host "Enter API base URL (optional; press Enter to skip)"

Write-Host "Writing config (env.vars)..." -ForegroundColor Yellow
& openclaw config set env.vars.OPENAI_API_KEY "$apiKey" | Out-Null
if(-not [string]::IsNullOrWhiteSpace($baseUrl)){
  & openclaw config set env.vars.OPENAI_BASE_URL "$baseUrl" | Out-Null
}

Write-Host "Restarting gateway..." -ForegroundColor Yellow
try { & openclaw gateway restart | Out-Null } catch { Write-Host "gateway restart failed (maybe not running yet)." -ForegroundColor Yellow }

Write-Host "Running checks..." -ForegroundColor Yellow
& openclaw status
& openclaw doctor

Write-Host "\nOpen dashboard UI: openclaw dashboard" -ForegroundColor Green
