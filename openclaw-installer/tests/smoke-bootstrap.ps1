# Smoke test: Windows bootstrap script supports -DryRun
$ErrorActionPreference = 'Stop'
$script = Join-Path $PSScriptRoot "..\scripts\bootstrap-openclaw.ps1"
& powershell -ExecutionPolicy Bypass -File $script -DryRun -SkipDockerPrompt | Out-String | Write-Output
