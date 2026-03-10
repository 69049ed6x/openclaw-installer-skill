<#
Feishu quick setup (Windows)
- Asks for App ID + App Secret
- Writes into OpenClaw config
- Restarts gateway

Source:
- https://docs.openclaw.ai/zh-CN/channels/feishu

Security:
- Never hardcode secrets in this repo.
#>

$ErrorActionPreference = 'Stop'
Write-Host "=== Feishu setup for OpenClaw ==="

$appId = if($env:FEISHU_APP_ID){ $env:FEISHU_APP_ID } else { Read-Host "Enter Feishu App ID (cli_...)" }
$appSecret = if($env:FEISHU_APP_SECRET){ $env:FEISHU_APP_SECRET } else { Read-Host "Enter Feishu App Secret" }

& openclaw config set channels.feishu.enabled true | Out-Null
& openclaw config set channels.feishu.accounts.default.appId "$appId" | Out-Null
& openclaw config set channels.feishu.accounts.default.appSecret "$appSecret" | Out-Null

Write-Host "Restarting gateway..."
& openclaw gateway restart

Write-Host "Done. Check: openclaw status" -ForegroundColor Green
