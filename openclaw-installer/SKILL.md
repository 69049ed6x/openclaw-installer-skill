---
name: OpenClaw + OpenCode Complete Installer
description: Complete installation guide for OpenClaw AND OpenCode across all platforms. Includes how to download and use this skill in OpenCode, plus operations/maintenance guide with user data collection.
version: 2.0.0
author: OpenClaw Community
tags:
  - installation
  - setup
  - deployment
  - docker
  - production
  - opencode
  - skill
  - operations
triggers:
  - install openclaw
  - setup openclaw
  - deploy openclaw
  - openclaw installation
  - openclaw not working
  - install opencode
  - opencode setup
  - opencode skill
---

# OpenClaw Installation Skill

## Overview

This skill provides comprehensive installation instructions for OpenClaw across all supported platforms. OpenClaw is a powerful AI-powered coding assistant that runs in your terminal.

## Quick Start

> ⚠️ **VERIFY THIS TABLE against official docs** before publishing.

Choose your platform for the fastest installation path:

| Platform | Command | Source |
|----------|---------|--------|
| Windows | `winget install openclaw` or `npm install -g openclaw` | https://docs.openclaw.ai/install |
| macOS | `brew install openclaw` or `npm install -g openclaw` | https://docs.openclaw.ai/install |
| Linux | `npm install -g openclaw` | https://docs.openclaw.ai/install |
| Docker | See docs/docker.md | https://docs.openclaw.ai/install/docker |

## Prerequisites

### All Platforms
> ⚠️ **CORRECTION NEEDED**: Previous version said v18+, but official docs say **Node 22+ required**.

- **Node.js**: **v22 or higher** (official requirement) — see https://docs.openclaw.ai/install/node
- **npm**: v9.0.0 or higher (comes with Node.js)
- **API Key**: Anthropic API key or compatible provider

### System Requirements
> ⚠️ **UNVERIFIED**: The following numbers are NOT from official docs — verify before publishing.

- **RAM**: Minimum 4GB, recommended 8GB+ (UNVERIFIED — could not locate official RAM specs)
- **Disk**: Minimum 500MB free space (UNVERIFIED)
- **Network**: Stable internet connection for API calls

---

## Platform-Specific Installation

> ⚠️ **CORRECTION**: The official docs recommend the **installer script** as the primary method for ALL platforms. Only use npm/pnpm if you already have Node 22+.

### Recommended: Installer Script (All Platforms)

**macOS / Linux / WSL2:**
```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

**Windows (PowerShell):**
```powershell
iwr -useb https://openclaw.ai/install.ps1 | iex
```

> **Source**: https://docs.openclaw.ai/install (accordion "Installer script")

---

### Windows (Alternative: npm)

> ⚠️ **CORRECTIONS NEEDED**: Check against official docs.

#### Method 1: Using winget (Recommended)
```powershell
# Install via Windows Package Manager
winget install openclaw

# Verify installation
openclaw --version
```
> **Source**: https://docs.openclaw.ai/install/node shows `winget install OpenJS.NodeJS.LTS` for Node; OpenClaw via winget needs verification.

#### Method 2: Using npm
```powershell
# Install Node.js first (if not using installer script)
winget install OpenJS.NodeJS.LTS

# Install globally
npm install -g openclaw

# Verify installation
openclaw --version
```
> **Source**: https://docs.openclaw.ai/install (npm install -g openclaw@latest) — confirmed.

#### Method 3: Using Chocolatey
```powershell
# Install Chocolatey first if not available
# Then install OpenClaw
choco install openclaw

# Verify
openclaw --version
```

#### Windows-Specific Configuration
```powershell
# Set API key (PowerShell)
$env:ANTHROPIC_API_KEY="your-api-key-here"

# Or permanently in user environment
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "your-api-key-here", "User")

# Create workspace directory
mkdir $env:USERPROFILE\.openclaw\workspace
```

**See**: [docs/windows.md](docs/windows.md) for detailed Windows instructions.

---

### Recommended: Installer Script (All Platforms)

> ⚠️ **CORRECTION**: The official docs recommend the **installer script** as the primary method for ALL platforms. Only use npm/pnpm if you already have Node 22+.

**macOS / Linux / WSL2:**
```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

**Windows (PowerShell):**
```powershell
iwr -useb https://openclaw.ai/install.ps1 | iex
```

> **Source**: https://docs.openclaw.ai/install (accordion "Installer script")

---

### macOS (Alternative: npm/Homebrew)

> ⚠️ **CORRECTIONS NEEDED**: Check against official docs.

#### Method 1: Using Homebrew (Recommended)
```bash
# Install Homebrew if not present
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Node.js 22+ (required)
brew install node

# Install OpenClaw
brew install openclaw

# Verify installation
openclaw --version
```
> **Source**: https://docs.openclaw.ai/install + https://docs.openclaw.ai/install/node confirms Homebrew as macOS method.

#### Method 2: Using npm
```bash
# Install Node.js 22+ via Homebrew
brew install node

# Install OpenClaw globally
npm install -g openclaw

# Verify installation
openclaw --version
```
> **Source**: https://docs.openclaw.ai/install (npm method) — confirmed.

---

### macOS Configuration
```bash
# Add to ~/.zshrc or ~/.bash_profile
export ANTHROPIC_API_KEY="your-api-key-here"

# Reload shell
source ~/.zshrc

# Create workspace
mkdir -p ~/.openclaw/workspace
```

**See**: [docs/macos.md](docs/macos.md) for detailed macOS instructions.

---

### Linux (Ubuntu/Debian)

> ⚠️ **CORRECTION**: Official docs recommend **installer script** as primary method.

#### Method 1: Using installer script (Recommended)
```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```
> **Source**: https://docs.openclaw.ai/install (accordion "Installer script")

#### Method 2: Using npm (if you already have Node 22+)
```bash
# Install Node.js 22+ via NodeSource (if needed)
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs

# Install OpenClaw
sudo npm install -g openclaw
openclaw onboard --install-daemon
```
> **Source**: https://docs.openclaw.ai/install (accordion "npm / pnpm")

#### Method 3: Using nvm (for developers)
```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc

# Install Node.js 22
nvm install 22
nvm use 22

# Install OpenClaw
npm install -g openclaw
```

#### Linux Configuration
```bash
# Add to ~/.bashrc or ~/.zshrc
export ANTHROPIC_API_KEY="your-api-key-here"

# Reload
source ~/.bashrc

# Create workspace with proper permissions
mkdir -p ~/.openclaw/workspace
chmod 700 ~/.openclaw
```

**See**: [docs/linux-ubuntu.md](docs/linux-ubuntu.md) for detailed Linux instructions.

---

### Raspberry Pi

#### Prerequisites
- Raspberry Pi 4/5 (2GB+ recommended; 64-bit OS recommended)

> **Source**: https://docs.openclaw.ai/platforms/raspberry-pi

#### Installation (Recommended)

> ⚠️ Official docs prefer the installer script + Node 22+.

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js 22 (ARM64)
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs

# Install OpenClaw
npm install -g openclaw@latest
openclaw onboard --install-daemon
```

> **Source**: https://docs.openclaw.ai/platforms/raspberry-pi and https://docs.openclaw.ai/install

#### Performance Optimization for Pi
```bash
# Increase swap (if needed)
sudo dphys-swapfile swapoff
sudo sed -i 's/CONF_SWAPSIZE=.*/CONF_SWAPSIZE=2048/' /etc/dphys-swapfile
sudo dphys-swapfile setup
sudo dphys-swapfile swapon

# Set memory limit for Node.js
export NODE_OPTIONS="--max-old-space-size=2048"
```

**See**: [docs/raspberry-pi.md](docs/raspberry-pi.md) for detailed Raspberry Pi instructions.

---

### Docker

> ⚠️ **CORRECTION**: Official docs recommend using `docker-setup.sh` from the OpenClaw repo for the Docker gateway flow.

#### Recommended (Docker Compose via docker-setup.sh)

```bash
./docker-setup.sh
```

> **Source**: https://docs.openclaw.ai/install/docker ("Quick start (recommended)")

#### Notes
- Image names like `openclaw/openclaw:latest` are **UNVERIFIED** in this skill unless confirmed by the official docs page.
- For full details, see: `docs/docker.md` in this skill (now includes Sources) and the official page above.

#### Building Custom Image
```bash
# Clone and build
git clone https://github.com/openclaw/openclaw.git
cd openclaw
docker build -t openclaw-custom .
```

**See**: [docs/docker.md](docs/docker.md) for detailed Docker instructions.
**Files**: [docker/docker-compose.yml](docker/docker-compose.yml), [docker/Dockerfile](docker/Dockerfile)

---

### VPS Deployment

#### Supported Providers
- AWS EC2
- Google Cloud Compute
- DigitalOcean Droplets
- Linode
- Vultr
- Hetzner

#### Minimum VPS Requirements
- **CPU**: 2 vCPUs
- **RAM**: 4GB (8GB recommended)
- **Storage**: 20GB SSD
- **OS**: Ubuntu 22.04 LTS (recommended)

#### Quick VPS Setup
```bash
# SSH into your VPS
ssh root@your-vps-ip

# Update system
apt update && apt upgrade -y

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# Install OpenClaw
npm install -g openclaw

# Create dedicated user (security best practice)
useradd -m -s /bin/bash openclaw
su - openclaw

# Configure API key
echo 'export ANTHROPIC_API_KEY="your-key"' >> ~/.bashrc
source ~/.bashrc

# Create workspace
mkdir -p ~/.openclaw/workspace
```

#### Running as a Service (systemd)
```ini
# /etc/systemd/system/openclaw.service
[Unit]
Description=OpenClaw AI Assistant
After=network.target

[Service]
Type=simple
User=openclaw
WorkingDirectory=/home/openclaw/.openclaw/workspace
Environment=ANTHROPIC_API_KEY=your-key
ExecStart=/usr/bin/openclaw --daemon
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable openclaw
sudo systemctl start openclaw
```

**See**: [docs/vps.md](docs/vps.md) for detailed VPS deployment instructions.

---

## Configuration

### API Key Setup

OpenClaw supports multiple AI providers:

```bash
# Anthropic (default)
export ANTHROPIC_API_KEY="sk-ant-..."

# OpenAI compatible
export OPENAI_API_KEY="sk-..."
export OPENAI_BASE_URL="https://api.openai.com/v1"

# Azure OpenAI
export AZURE_OPENAI_API_KEY="..."
export AZURE_OPENAI_ENDPOINT="https://your-resource.openai.azure.com"

# Local models (Ollama)
export OLLAMA_HOST="http://localhost:11434"
```

### Configuration File

Create `~/.openclaw/config.json`:
```json
{
  "defaultModel": "claude-sonnet-4-20250514",
  "workspace": "~/.openclaw/workspace",
  "theme": "dark",
  "editor": "code",
  "git": {
    "autoCommit": false,
    "signCommits": true
  },
  "logging": {
    "level": "info",
    "file": "~/.openclaw/logs/openclaw.log"
  }
}
```

### Skills Directory

Place custom skills in:
- **User skills**: `~/.openclaw/skills/`
- **Project skills**: `./skills/` (in your project)
- **Global skills**: `/usr/share/openclaw/skills/`

---

## Verification

### Test Installation
```bash
# Check version
openclaw --version

# Check configuration
openclaw config --list

# Run self-test
openclaw doctor

# Test API connection
openclaw test-api
```

### Expected Output
```
OpenClaw v1.x.x
Node.js v20.x.x
npm v10.x.x

Configuration:
  API Key: [CONFIGURED]
  Workspace: ~/.openclaw/workspace
  Skills: 15 loaded

All systems operational!
```

---

## Troubleshooting

### Common Issues

#### 1. "command not found: openclaw"

**Cause**: PATH not configured or installation incomplete.

**Solutions**:
```bash
# Check if npm global bin is in PATH
npm config get prefix
# Add to PATH in ~/.bashrc or ~/.zshrc:
export PATH="$(npm config get prefix)/bin:$PATH"

# Or reinstall with sudo
sudo npm install -g openclaw
```

#### 2. "ANTHROPIC_API_KEY not set"

**Cause**: Environment variable not exported.

**Solutions**:
```bash
# Temporary (current session)
export ANTHROPIC_API_KEY="your-key"

# Permanent (add to shell config)
echo 'export ANTHROPIC_API_KEY="your-key"' >> ~/.bashrc
source ~/.bashrc

# Windows PowerShell (permanent)
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "your-key", "User")
```

#### 3. "EACCES: permission denied"

**Cause**: npm global directory permissions issue.

**Solutions**:
```bash
# Option 1: Fix permissions
sudo chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share}

# Option 2: Use nvm (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install --lts
npm install -g openclaw

# Option 3: Configure npm to use different directory
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
npm install -g openclaw
```

#### 4. "Node.js version too old"

**Cause**: OpenClaw requires Node.js 18+.

**Solutions**:
```bash
# Check version
node --version

# Update via nvm
nvm install 20
nvm use 20

# Update via package manager (Ubuntu)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Update via Homebrew (macOS)
brew upgrade node
```

#### 5. "API request failed" / "Rate limit exceeded"

**Cause**: API key invalid or rate limited.

**Solutions**:
```bash
# Verify API key format
echo $ANTHROPIC_API_KEY | head -c 10
# Should start with "sk-ant-"

# Test API directly
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"claude-sonnet-4-20250514","max_tokens":10,"messages":[{"role":"user","content":"Hi"}]}'

# If rate limited, wait or upgrade plan
```

#### 6. "Cannot find module" errors

**Cause**: Corrupted installation or dependency issues.

**Solutions**:
```bash
# Clear npm cache and reinstall
npm cache clean --force
npm uninstall -g openclaw
npm install -g openclaw

# If using nvm, try fresh Node.js install
nvm install 20 --reinstall-packages-from=current
```

#### 7. Docker: "Permission denied" on volumes

**Cause**: UID/GID mismatch between host and container.

**Solutions**:
```bash
# Run with current user
docker run -it --rm \
  --user $(id -u):$(id -g) \
  -v $(pwd):/workspace \
  openclaw/openclaw:latest

# Or fix permissions on host
chmod -R 777 ./workspace  # Less secure
```

#### 8. Windows: "Scripts disabled" error

**Cause**: PowerShell execution policy.

**Solutions**:
```powershell
# Check policy
Get-ExecutionPolicy

# Allow scripts (run as Administrator)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Or use cmd.exe instead
cmd /c openclaw
```

#### 9. Raspberry Pi: "Out of memory"

**Cause**: Insufficient RAM for Node.js operations.

**Solutions**:
```bash
# Increase swap
sudo dphys-swapfile swapoff
sudo sed -i 's/CONF_SWAPSIZE=.*/CONF_SWAPSIZE=2048/' /etc/dphys-swapfile
sudo dphys-swapfile setup
sudo dphys-swapfile swapon

# Limit Node.js memory
export NODE_OPTIONS="--max-old-space-size=1536"
```

#### 10. SSL/TLS Certificate errors

**Cause**: Outdated CA certificates or proxy interference.

**Solutions**:
```bash
# Update CA certificates (Linux)
sudo apt install ca-certificates
sudo update-ca-certificates

# Bypass (not recommended for production)
export NODE_TLS_REJECT_UNAUTHORIZED=0

# If behind proxy
export HTTP_PROXY="http://proxy:port"
export HTTPS_PROXY="http://proxy:port"
npm config set proxy http://proxy:port
npm config set https-proxy http://proxy:port
```

---

### Diagnostic Commands

```bash
# Full system diagnostic
openclaw doctor --verbose

# Check network connectivity
openclaw test-connection

# Verify skills loading
openclaw skills --list

# Check workspace permissions
openclaw workspace --check

# Generate debug report
openclaw debug-report > ~/openclaw-debug.txt
```

---

### Getting Help

1. **Documentation**: https://docs.openclaw.ai
2. **GitHub Issues**: https://github.com/openclaw/openclaw/issues
3. **Discord**: https://discord.gg/openclaw
4. **Stack Overflow**: Tag `[openclaw]`

When reporting issues, include:
- Output of `openclaw doctor`
- Your OS and version
- Node.js version (`node --version`)
- npm version (`npm --version`)
- Error messages (full output)

---

## Updating

### Update to Latest Version
```bash
# npm
npm update -g openclaw

# Homebrew
brew upgrade openclaw

# Docker
docker pull openclaw/openclaw:latest
```

### Check for Updates
```bash
# Check current vs latest
openclaw --version
npm show openclaw version
```

---

## Uninstallation

### Complete Removal
```bash
# npm
npm uninstall -g openclaw

# Remove configuration and data
rm -rf ~/.openclaw

# Homebrew
brew uninstall openclaw

# Docker
docker rmi openclaw/openclaw
docker volume rm openclaw-data
```

---

## OpenCode 安装指南 (5岁小孩都能看懂)

### 什么是 OpenCode？

OpenCode 是一个可以让你用 AI 帮写代码的工具。就像有一个超级聪明的程序员朋友，随时帮你写代码、修 bug！

### 第一步：下载安装包

**Windows 用户：**
1. 打开浏览器，访问这个网站：https://opencode.ai
2. 点击 "Download" 或 "下载" 按钮
3. 选择 "Windows 版本"
4. 下载安装包（大约 100MB）

**Mac 用户：**
1. 打开浏览器，访问：https://opencode.ai
2. 点击下载，选择 "macOS 版本"
3. 把下载的文件拖到 "应用程序" 文件夹

**Linux 用户：**
1. 打开终端（黑黑的像黑客的屏幕）
2. 输入这个命令然后按回车：
```bash
curl -fsSL https://opencode.ai/install.sh | bash
```

### 第二步：安装

**Windows：**
1. 双击下载的文件
2. 一直点 "下一步" 或 "Next"
3. 完成后，点击 "完成"

**Mac：**
1. 打开 "应用程序" 文件夹
2. 双击 OpenCode
3. 第一次打开时点 "打开"

**Linux：**
1. 在终端输入：`sudo dpkg -i opencode_*.deb`
2. 或者：`sudo rpm -i opencode_*.rpm`

### 第三步：打开和使用

1. 找到 OpenCode 图标（像一个小箱子）
2. 双击打开
3. 第一次需要登录（用 GitHub 账号）
4. 登录后就能和 AI 对话让它帮你写代码了！

### 常见问题

**打不开怎么办？**
- Windows：右键点击图标，选择 "用管理员身份运行"
- Mac：打开 "系统设置" -> "隐私与安全性"，允许运行

**登录不了？**
- 检查网络是否正常
- 确认 GitHub 账号密码正确

---

## 在 OpenCode 里“使用”这套安装教程（已验证版）

> 重要：OpenCode CLI（v1.2.24）的 `--help` 输出里 **没有** `skills` 相关子命令，因此 **OpenCode 本身不负责安装/管理 OpenClaw Skills**。
>
> 这套内容是 **OpenClaw Skill**（目录：`skills/openclaw-installer/`）。

### 你可以怎么用 OpenCode？

你可以用 OpenCode 来：
- 阅读这些安装文档（让 AI 帮你总结/翻译/检查步骤）
- 让 AI 帮你把命令按你的系统改成可直接复制粘贴的版本
- 让 AI 帮你生成“按你机器情况定制”的安装清单

### 方式 A：直接让 OpenCode 阅读本地文件

在存放该 skill 的目录打开终端，然后运行：

```bash
# 进入 skill 目录（Windows PowerShell 示例）
cd C:\Users\24512\.openclaw\workspace\skills\openclaw-installer

# 让 OpenCode 读取并总结（示例）
opencode run "Read SKILL.md and docs/windows.md. Summarize the Windows install steps into a 10-step checklist."
```

### 方式 B：让 OpenCode 帮你做运维（基于它自带命令）

OpenCode `--help` 中已验证存在这些运维相关命令：
- `opencode serve`（无界面 server）
- `opencode web`（启动并打开 web）
- `opencode session`（会话管理）
- `opencode stats`（用量统计）
- `opencode export/import`（导出/导入）
- `opencode upgrade/uninstall`（升级/卸载）

示例：
```bash
opencode stats
opencode session list
opencode export <sessionID>
```

---

## 运维指南：收集用户信息

### 为什么收集用户信息？

帮助开发者了解用户如何使用 OpenClaw 和 OpenCode，改进产品！

### 收集什么信息？

| 信息类型 | 用途 | 是否必须 |
|----------|------|----------|
| 操作系统版本 | 适配不同系统 | 必须 |
| OpenClaw 版本 | 排查问题 | 必须 |
| OpenCode 版本 | 排查问题 | 必须 |
| Node.js 版本 | 排查兼容问题 | 必须 |
| 安装方式 | 优化安装流程 | 推荐 |
| 错误日志 | 修复 bug | 必须 |
| 使用时长 | 了解用户习惯 | 可选 |
| 功能偏好 | 新功能规划 | 可选 |
| 反馈建议 | 产品改进 | 可选 |

### 如何收集用户信息

#### 方法一：自动收集（推荐）

创建 `scripts/collect-user-info.sh`：

```bash
#!/bin/bash
# 用户信息收集脚本

echo "=== OpenClaw 用户信息收集 ==="

# 系统信息
echo "操作系统: $(uname -a)"
echo "系统版本: $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d= -f2)"

# OpenClaw 版本
if command -v openclaw &> /dev/null; then
    echo "OpenClaw版本: $(openclaw --version)"
    echo "OpenClaw状态: $(openclaw status --json 2>/dev/null)"
fi

# OpenCode 版本
if command -v opencode &> /dev/null; then
    echo "OpenCode版本: $(opencode --version)"
fi

# Node.js 版本
echo "Node.js版本: $(node --version)"
echo "npm版本: $(npm --version)"

# Docker 版本
if command -v docker &> /dev/null; then
    echo "Docker版本: $(docker --version)"
fi

# 错误日志
echo "=== 最近错误日志 ==="
tail -50 ~/.openclaw/logs/*.log 2>/dev/null

# 保存到文件
DATE=$(date +%Y%m%d-%H%M%S)
FILENAME="user-info-${DATE}.txt"
{
    echo "=== 收集时间: $(date) ==="
    echo "=== 系统信息 ==="
    uname -a
    echo "=== OpenClaw 版本 ==="
    openclaw --version 2>/dev/null
    echo "=== OpenCode 版本 ==="
    opencode --version 2>/dev/null
    echo "=== Node.js 版本 ==="
    node --version
    echo "=== 错误日志 ==="
    tail -100 ~/.openclaw/logs/*.log 2>/dev/null
} > ~/$FILENAME

echo "信息已保存到: ~/$FILENAME"
```

#### 方法二：手动收集

```bash
# 一键收集所有信息
bash scripts/collect-user-info.sh

# 或者逐个执行
uname -a > user-info.txt
openclaw --version >> user-info.txt
node --version >> user-info.txt
```

#### 方法三：自动上报（可选）

创建 `scripts/auto-report.sh`：

```bash
#!/bin/bash
# 自动上报用户信息（需要配置服务器 URL）

SERVER_URL="https://your-report-server.com/api/report"

# 收集基本信息
INFO=$(cat <<EOF
{
  "os": "$(uname -a)",
  "openclaw_version": "$(openclaw --version 2>/dev/null)",
  "opencode_version": "$(opencode --version 2>/dev/null)",
  "node_version": "$(node --version)",
  "timestamp": "$(date -Iseconds)"
}
EOF
)

# 上报服务器
curl -X POST "$SERVER_URL" \
  -H "Content-Type: application/json" \
  -d "$INFO"

echo "信息已上报"
```

### 用户隐私保护

1. **获取同意**：收集前必须告知用户并获得同意
2. **匿名化处理**：不收集个人身份信息（如姓名、邮箱）
3. **本地存储**：信息保存在本地，不自动上传
4. **可删除**：用户可以随时删除已收集的信息

### 数据分析

收集后可以分析：
- 最常用的安装方式
- 最常遇到的错误
- 用户活跃时间段
- 功能使用频率
- 系统兼容性报告

---

## 完整安装示例（一步步来）

### 第一天：安装 OpenClaw

```bash
# 1. 检查电脑有没有 Node.js
node --version

# 2. 没有的话去下载：https://nodejs.org

# 3. 安装 OpenClaw
npm install -g openclaw

# 4. 验证安装成功
openclaw --version

# 5. 第一次设置
openclaw onboard
```

### 第二天：安装 OpenCode

```bash
# 1. 去 opencode.ai 下载

# 2. 安装完成后打开

# 3. 用 GitHub 账号登录

# 4. 测试一下
!help
```

### 第三天：把安装 Skill 加进来

```bash
# 1. 复制 skill 文件夹到正确位置
cp -r openclaw-installer ~/.opencode/skills/

# 2. 在 OpenCode 里验证
!skills list

# 3. 试试看
!openclaw install help
```

### 第四天：收集用户信息

```bash
# 1. 运行收集脚本
bash scripts/collect-user-info.sh

# 2. 查看收集了什么
cat user-info-*.txt

# 3. （可选）上报给开发者
bash scripts/auto-report.sh
```

---

## Resources

- [Platform-specific guides](docs/)
- [Docker files](docker/)
- [Test scripts](tests/)
- [Installation scripts](scripts/)
- [OpenCode Official](https://opencode.ai)
- [OpenClaw Official](https://docs.openclaw.ai)

## License

MIT License - See LICENSE file for details.
