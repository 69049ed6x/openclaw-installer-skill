param(
  [Parameter(Mandatory=$true)][string]$RepoName,
  [string]$Description = "OpenClaw installation skill (multi-platform guides + troubleshooting)",
  [switch]$Private
)

# Requires: a GitHub token with `repo` scope in $env:GITHUB_TOKEN
# Usage:
#   $env:GITHUB_TOKEN="ghp_..."
#   .\scripts\create_github_repo_and_push.ps1 -RepoName "openclaw-installer-skill" -Description "..." -Private:$false

$ErrorActionPreference = "Stop"

if (-not $env:GITHUB_TOKEN) {
  throw "GITHUB_TOKEN is not set. Create a GitHub Personal Access Token and set it to env var GITHUB_TOKEN."
}

$headers = @{ Authorization = "token $env:GITHUB_TOKEN"; "User-Agent" = "openclaw-installer-skill"; Accept = "application/vnd.github+json" }

# Get current user login
$user = Invoke-RestMethod -Uri "https://api.github.com/user" -Headers $headers
$owner = $user.login

$body = @{ name = $RepoName; description = $Description; private = [bool]$Private } | ConvertTo-Json

Write-Host "Creating repo $owner/$RepoName ..."
Invoke-RestMethod -Method Post -Uri "https://api.github.com/user/repos" -Headers $headers -Body $body | Out-Null

$remote = "https://$($owner):$($env:GITHUB_TOKEN)@github.com/$owner/$RepoName.git"

Write-Host "Adding remote and pushing ..."
cd (Split-Path $PSScriptRoot -Parent)

git remote remove origin 2>$null
& git remote add origin $remote
& git branch -M main
& git push -u origin main

Write-Host "Done: https://github.com/$owner/$RepoName"