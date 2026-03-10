# Windows Installation Guide

Complete guide for installing OpenClaw on Windows 10/11.

## Prerequisites

### System Requirements
- Windows 10 (1903+) or Windows 11
- 64-bit processor
- 4GB RAM minimum (8GB recommended)
- 500MB free disk space
- Internet connection

### Required Software
- Node.js 18+ (20 LTS recommended)
- npm 9+ (included with Node.js)

## Sources (this file)

Primary sources used to verify commands and recommendations:
- OpenClaw official install docs: https://docs.openclaw.ai/install
  - Windows installer script (PowerShell): https://openclaw.ai/install.ps1 (linked from docs)
  - Recommendation to use WSL2 on Windows: same page (note section)
- npm package page (global install): https://www.npmjs.com/package/openclaw

---

## Installation Methods

### Method 1: Windows Package Manager (winget) - Recommended

```powershell
# Open PowerShell or Windows Terminal as Administrator
winget install openclaw

# Verify installation
openclaw --version
```

### Method 2: npm Global Install

#### Step 1: Install Node.js

**Option A: Official Installer**
1. Download from https://nodejs.org/
2. Choose "LTS" version (20.x.x)
3. Run installer with default settings
4. Check "Automatically install necessary tools"

**Option B: Using winget**
```powershell
winget install OpenJS.NodeJS.LTS
```

**Option C: Using Chocolatey**
```powershell
choco install nodejs-lts
```

#### Step 2: Verify Node.js Installation
```powershell
# Check versions
node --version   # Should show v20.x.x
npm --version    # Should show v10.x.x
```

#### Step 3: Install OpenClaw
```powershell
# Install globally
npm install -g openclaw

# Verify
openclaw --version
```

### Method 3: Chocolatey

```powershell
# Install Chocolatey (if not present)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install OpenClaw
choco install openclaw

# Verify
openclaw --version
```

### Method 4: Scoop

```powershell
# Install Scoop (if not present)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# Add extras bucket
scoop bucket add extras

# Install OpenClaw
scoop install openclaw

# Verify
openclaw --version
```

## Configuration

### Set API Key

**Temporary (Current Session)**
```powershell
$env:ANTHROPIC_API_KEY = "sk-ant-your-key-here"
```

**Permanent (User Level)**
```powershell
# PowerShell
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-ant-your-key-here", "User")

# Restart PowerShell to apply
```

**Permanent (System Level - requires Admin)**
```powershell
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-ant-your-key-here", "Machine")
```

**Using GUI**
1. Press `Win + R`, type `sysdm.cpl`, press Enter
2. Go to "Advanced" tab
3. Click "Environment Variables"
4. Under "User variables", click "New"
5. Variable name: `ANTHROPIC_API_KEY`
6. Variable value: `sk-ant-your-key-here`
7. Click OK

### Create Workspace Directory

```powershell
# Create directory
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.openclaw\workspace"

# Navigate to it
cd "$env:USERPROFILE\.openclaw\workspace"
```

### Configuration File

Create `%USERPROFILE%\.openclaw\config.json`:

```json
{
  "defaultModel": "claude-sonnet-4-20250514",
  "workspace": "%USERPROFILE%\\.openclaw\\workspace",
  "theme": "dark",
  "editor": "code",
  "shell": "powershell",
  "git": {
    "autoCommit": false,
    "signCommits": false
  }
}
```

## Windows Terminal Integration

### Add OpenClaw Profile

Edit Windows Terminal settings (`Ctrl+,`) and add:

```json
{
  "profiles": {
    "list": [
      {
        "name": "OpenClaw",
        "commandline": "openclaw",
        "icon": "🦞",
        "startingDirectory": "%USERPROFILE%\\.openclaw\\workspace",
        "colorScheme": "One Half Dark"
      }
    ]
  }
}
```

### PowerShell Profile Integration

Add to `$PROFILE` (create if doesn't exist):

```powershell
# OpenClaw aliases
Set-Alias -Name oc -Value openclaw

# Function for quick workspace access
function Enter-OpenClaw {
    Set-Location "$env:USERPROFILE\.openclaw\workspace"
    openclaw
}
Set-Alias -Name ocw -Value Enter-OpenClaw

# Verify API key on startup
if (-not $env:ANTHROPIC_API_KEY) {
    Write-Warning "ANTHROPIC_API_KEY not set. OpenClaw may not work properly."
}
```

## WSL Integration

If you prefer Linux environment on Windows:

```powershell
# Enable WSL
wsl --install

# Install Ubuntu
wsl --install -d Ubuntu

# Inside WSL Ubuntu
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
npm install -g openclaw
```

## Troubleshooting

### "Scripts disabled" Error

```powershell
# Check current policy
Get-ExecutionPolicy -List

# Allow local scripts (recommended)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# If using company-managed machine
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

### "command not found: openclaw"

```powershell
# Check if npm global bin is in PATH
npm config get prefix

# Add to PATH manually
$npmPrefix = npm config get prefix
$env:PATH += ";$npmPrefix"

# Make permanent
[System.Environment]::SetEnvironmentVariable(
    "PATH",
    [System.Environment]::GetEnvironmentVariable("PATH", "User") + ";$npmPrefix",
    "User"
)
```

### EACCES Permission Errors

```powershell
# Run PowerShell as Administrator, then:
npm cache clean --force
npm install -g openclaw
```

### Node.js Not Recognized

```powershell
# Refresh environment variables
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")

# Or restart PowerShell/Terminal
```

### Antivirus Blocking

Some antivirus software may block Node.js or npm:
1. Add exclusion for `%APPDATA%\npm`
2. Add exclusion for `%USERPROFILE%\.openclaw`
3. Add exclusion for Node.js installation directory

### Slow Performance

```powershell
# Disable Windows Defender real-time scanning for workspace
Add-MpPreference -ExclusionPath "$env:USERPROFILE\.openclaw"

# Increase Node.js memory if needed
$env:NODE_OPTIONS = "--max-old-space-size=4096"
```

## Updating

```powershell
# npm
npm update -g openclaw

# winget
winget upgrade openclaw

# Chocolatey
choco upgrade openclaw

# Scoop
scoop update openclaw
```

## Uninstallation

```powershell
# npm
npm uninstall -g openclaw

# Remove data
Remove-Item -Recurse -Force "$env:USERPROFILE\.openclaw"

# Remove environment variable
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $null, "User")

# winget
winget uninstall openclaw

# Chocolatey
choco uninstall openclaw

# Scoop
scoop uninstall openclaw
```

## Best Practices

1. **Use Windows Terminal** - Better experience than cmd.exe or basic PowerShell
2. **Enable Developer Mode** - Settings > Privacy & Security > For developers
3. **Use Git Bash** - Alternative shell with Unix-like commands
4. **Regular Updates** - Keep Node.js and OpenClaw updated
5. **Backup Config** - Keep `.openclaw` folder in your backup routine
