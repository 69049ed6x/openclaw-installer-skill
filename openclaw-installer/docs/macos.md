# macOS Installation Guide

## Sources (this file)

Primary sources used in this document:
- OpenClaw official install overview (macOS install methods + Node 22+ requirement): https://docs.openclaw.ai/install
- OpenClaw Node.js requirements + macOS install method: https://docs.openclaw.ai/install/node
- OpenClaw macOS VMs (sandboxing / isolation option): https://docs.openclaw.ai/install/macos-vm

Notes:
- Any macOS-specific details not present in the official docs above are marked as UNVERIFIED and should be double-checked.

- OpenClaw official macOS platform docs: https://docs.openclaw.ai/platforms/macos

---

Complete guide for installing OpenClaw on macOS (Intel and Apple Silicon).

## Prerequisites

### System Requirements
- macOS 11 Big Sur or newer (Monterey, Ventura, Sonoma recommended)
- Intel or Apple Silicon (M1/M2/M3) processor
- 4GB RAM minimum (8GB recommended)
- 500MB free disk space
- Internet connection

### Required Software
- Node.js 18+ (20 LTS recommended)
- npm 9+ (included with Node.js)
- Xcode Command Line Tools (for native modules)

## Installation Methods

### Method 1: Homebrew (Recommended)

#### Step 1: Install Homebrew
```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# For Apple Silicon, add to PATH
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Verify
brew --version
```

#### Step 2: Install OpenClaw
```bash
# Install
brew install openclaw

# Verify
openclaw --version
```

### Method 2: npm Global Install

#### Step 1: Install Node.js

**Option A: Via Homebrew (Recommended)**
```bash
brew install node

# Verify
node --version
npm --version
```

**Option B: Via nvm (Best for Development)**
```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Reload shell
source ~/.zshrc  # or ~/.bash_profile for bash

# Install Node.js LTS
nvm install --lts
nvm use --lts

# Verify
node --version
```

**Option C: Official Installer**
1. Download from https://nodejs.org/
2. Choose "LTS" version
3. Run the .pkg installer
4. Follow installation wizard

#### Step 2: Install OpenClaw
```bash
# Install globally
npm install -g openclaw

# Verify
openclaw --version
```

### Method 3: MacPorts

```bash
# Install MacPorts (from https://macports.org)

# Install Node.js
sudo port install nodejs20

# Install OpenClaw
npm install -g openclaw
```

## Configuration

### Set API Key

**Temporary (Current Session)**
```bash
export ANTHROPIC_API_KEY="sk-ant-your-key-here"
```

**Permanent (zsh - default on macOS)**
```bash
# Add to ~/.zshrc
echo 'export ANTHROPIC_API_KEY="sk-ant-your-key-here"' >> ~/.zshrc

# Reload
source ~/.zshrc
```

**Permanent (bash)**
```bash
# Add to ~/.bash_profile
echo 'export ANTHROPIC_API_KEY="sk-ant-your-key-here"' >> ~/.bash_profile

# Reload
source ~/.bash_profile
```

**Using macOS Keychain (Most Secure)**
```bash
# Store in keychain
security add-generic-password -a "$USER" -s "ANTHROPIC_API_KEY" -w "sk-ant-your-key-here"

# Retrieve in shell config (~/.zshrc)
export ANTHROPIC_API_KEY=$(security find-generic-password -a "$USER" -s "ANTHROPIC_API_KEY" -w 2>/dev/null)
```

### Create Workspace Directory

```bash
# Create workspace
mkdir -p ~/.openclaw/workspace

# Set permissions
chmod 700 ~/.openclaw
```

### Configuration File

Create `~/.openclaw/config.json`:

```json
{
  "defaultModel": "claude-sonnet-4-20250514",
  "workspace": "~/.openclaw/workspace",
  "theme": "dark",
  "editor": "code",
  "shell": "zsh",
  "git": {
    "autoCommit": false,
    "signCommits": true
  }
}
```

## iTerm2 Integration

### Create OpenClaw Profile

1. Open iTerm2 Preferences (`Cmd + ,`)
2. Go to Profiles > +
3. Configure:
   - Name: OpenClaw
   - Command: `/usr/local/bin/openclaw` (Intel) or `/opt/homebrew/bin/openclaw` (Apple Silicon)
   - Working Directory: `~/.openclaw/workspace`
   - Badge: 🦞

### Add to Profile

Add to `~/.zshrc`:
```bash
# OpenClaw aliases
alias oc="openclaw"
alias ocw="cd ~/.openclaw/workspace && openclaw"

# Quick project opener
function ocp() {
    cd ~/.openclaw/workspace/$1 && openclaw
}
```

## Apple Silicon Considerations

### Rosetta 2 (if needed)
```bash
# Install Rosetta 2 (for Intel-only packages)
softwareupdate --install-rosetta --agree-to-license
```

### Native ARM64 Installation
```bash
# Ensure using ARM64 Node.js
node -p "process.arch"  # Should show 'arm64'

# If showing x64, reinstall via Homebrew
arch -arm64 brew install node
```

### Terminal Architecture Check
```bash
# Check terminal architecture
arch
# Should show 'arm64' on Apple Silicon

# If showing 'i386', open Terminal with Rosetta disabled
# Right-click Terminal.app > Get Info > Uncheck "Open using Rosetta"
```

## Troubleshooting

### "Permission denied" Installing Globally

```bash
# Option 1: Fix npm permissions
sudo chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share}

# Option 2: Use nvm (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.zshrc
nvm install --lts
npm install -g openclaw

# Option 3: Change npm prefix
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
npm install -g openclaw
```

### "command not found: openclaw"

```bash
# Check npm global bin location
npm config get prefix

# Add to PATH if needed
echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# For Homebrew Node.js
echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc  # Apple Silicon
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc     # Intel
source ~/.zshrc
```

### Node.js Version Issues

```bash
# Check version
node --version

# If too old, update via Homebrew
brew upgrade node

# Or via nvm
nvm install --lts
nvm alias default lts/*
```

### Xcode Command Line Tools Missing

```bash
# Install
xcode-select --install

# If that fails
sudo rm -rf /Library/Developer/CommandLineTools
xcode-select --install
```

### SSL Certificate Errors

```bash
# Update CA certificates
brew install ca-certificates

# Or set Node.js to use system certs
export NODE_EXTRA_CA_CERTS=/etc/ssl/cert.pem
```

### Gatekeeper Blocking

```bash
# If macOS blocks the app
xattr -d com.apple.quarantine $(which openclaw)

# Or allow in System Preferences > Security & Privacy
```

### Slow on Apple Silicon

```bash
# Ensure running native, not Rosetta
file $(which node)
# Should show: "Mach-O 64-bit executable arm64"

# If showing x86_64, reinstall Node.js
arch -arm64 brew reinstall node
```

## Updating

```bash
# Homebrew
brew upgrade openclaw

# npm
npm update -g openclaw

# nvm (update Node.js too)
nvm install --lts --reinstall-packages-from=current
```

## Uninstallation

```bash
# Homebrew
brew uninstall openclaw

# npm
npm uninstall -g openclaw

# Remove configuration and data
rm -rf ~/.openclaw

# Remove from keychain (if used)
security delete-generic-password -a "$USER" -s "ANTHROPIC_API_KEY"
```

## Best Practices

1. **Use Homebrew** - Easiest way to manage Node.js and OpenClaw
2. **Use nvm for Development** - Easy Node.js version switching
3. **Store API Key in Keychain** - Most secure option
4. **Enable FileVault** - Encrypt your disk for security
5. **Use iTerm2** - Better terminal experience than Terminal.app
6. **Keep Updated** - Regular `brew update && brew upgrade`

## Additional Resources

- [Homebrew Documentation](https://docs.brew.sh/)
- [nvm Documentation](https://github.com/nvm-sh/nvm)
- [Node.js macOS Guide](https://nodejs.org/en/download/package-manager)
