# OpenClaw Linux Ubuntu 安装指南

## Sources (this file)

Primary source used to verify Linux installation commands:
- OpenClaw official install docs (Linux section): https://docs.openclaw.ai/install
- Systemd service example: https://docs.openclaw.ai/install (accordion "systemd" in the source docs)

## 系统要求

- **Ubuntu**: 20.04 LTS 或更高
- **Node.js**: v18+ (v20 推荐)
- **RAM**: 4GB 最低, 8GB 推荐
- **磁盘**: 10GB 可用空间

## 安装方法

### 方法一：官方安装脚本 (推荐)

```bash
# 下载并运行安装脚本
curl -fsSL https://openclaw.ai/install.sh | bash

# 或指定安装方法
curl -fsSL https://openclaw.ai/install.sh | bash -s -- --install-method npm
```

### 方法二：npm 全局安装

```bash
# 安装 Node.js 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# 验证安装
node --version  # v20.x.x

# 安装 OpenClaw
sudo npm install -g openclaw

# 验证
openclaw --version
```

### 方法三：pnpm

```bash
# 安装 pnpm
npm install -g pnpm

# 安装 OpenClaw
pnpm add -g openclaw
```

### 方法四：从源码编译

```bash
# 安装依赖
sudo apt install -y git build-essential

# 克隆仓库
git clone https://github.com/openclaw/openclaw.git
cd openclaw

# 安装 pnpm 并构建
npm install -g pnpm
pnpm install
pnpm build

# 链接命令
pnpm link --global openclaw
```

## 系统服务配置

### 创建 systemd 服务

```bash
sudo nano /etc/systemd/system/openclaw.service
```

```ini
[Unit]
Description=OpenClaw AI Assistant
After=network.target

[Service]
Type=simple
User=ubuntu
Group=ubuntu
WorkingDirectory=/home/ubuntu/.openclaw/workspace
Environment="PATH=/usr/local/bin:/usr/bin:/bin"
Environment="NODE_OPTIONS=--max-old-space-size=4096"
ExecStart=/usr/local/bin/openclaw gateway start
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

```bash
# 启用服务
sudo systemctl daemon-reload
sudo systemctl enable openclaw
sudo systemctl start openclaw

# 查看状态
sudo systemctl status openclaw

# 查看日志
sudo journalctl -u openclaw -f
```

## 防火墙配置

```bash
# 开放端口
sudo ufw allow 18789/tcp
sudo ufw reload

# 验证
sudo ufw status
```

## Nginx 反向代理 (可选)

```bash
sudo apt install -y nginx

sudo nano /etc/nginx/sites-available/openclaw
```

```nginx
server {
    listen 80;
    server_name openclaw.yourdomain.com;

    location / {
        proxy_pass http://127.0.0.1:18789;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_cache_bypass $http_upgrade;
    }
}
```

```bash
# 启用配置
sudo ln -s /etc/nginx/sites-available/openclaw /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## 常见问题

### 权限错误

```bash
# 修复 npm 全局目录权限
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# 重新安装
npm install -g openclaw
```

### Node.js 版本问题

```bash
# 使用 nvm 管理 Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install 20
nvm use 20
```

### 端口被占用

```bash
# 查看端口占用
sudo lsof -i :18789

# 杀死占用进程
sudo kill -9 <PID>

# 或修改端口
openclaw config set gateway.port 18790
```

## 卸载

```bash
sudo npm uninstall -g openclaw
sudo rm -rf ~/.openclaw
sudo rm /etc/systemd/system/openclaw.service
```
