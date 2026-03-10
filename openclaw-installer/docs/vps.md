# OpenClaw VPS 部署指南

## Sources (this file)

Primary sources used to verify VPS guidance and cloud setup model:
- OpenClaw official VPS hub: https://docs.openclaw.ai/vps
- OpenClaw official install docs (recommended clean base OS + installer script): https://docs.openclaw.ai/install

---

## Sources (this file)

Primary source used to verify VPS hosting options and tuning:
- OpenClaw official VPS hosting docs: https://docs.openclaw.ai/vps

---

## 推荐 VPS 提供商

| 提供商 | 推荐配置 | 价格 | 特点 |
|--------|----------|------|------|
| DigitalOcean | 2C/4G | $24/月 | 一键部署 |
| Linode | 2C/4G | $20/月 | 稳定快速 |
| Vultr | 2C/4G | $25/月 | 全球节点 |
| Hetzner | 2C/4G | €5/月 | 性价比高 |
| Contabo | 4C/8G | €5/月 | 大容量 |
| Oracle Cloud | 2C/4G | 免费 | 永久免费 |

## 系统要求

- **CPU**: 2 vCPU
- **RAM**: 4GB (8GB 推荐)
- **存储**: 20GB SSD
- **系统**: Ubuntu 22.04 LTS

## 部署步骤

### 1. 创建 VPS

以 DigitalOcean 为例：
1. 创建 Droplet
2. 选择 Ubuntu 22.04
3. 选择配置 (4GB RAM 推荐)
4. 添加 SSH 密钥
5. 创建

### 2. SSH 连接

```bash
ssh root@your-vps-ip
```

### 3. 安装 OpenClaw

```bash
# 更新系统
apt update && apt upgrade -y

# 安装 Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# 安装 OpenClaw
npm install -g openclaw

# 验证
openclaw --version
```

### 4. 配置

```bash
# 初始化配置
openclaw onboard --anthropic-api-key "your-key"

# 或手动配置
mkdir -p ~/.openclaw
nano ~/.openclaw/config.json
```

### 5. 配置 Systemd 服务

```bash
nano /etc/systemd/system/openclaw.service
```

```ini
[Unit]
Description=OpenClaw Gateway
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root
ExecStart=/usr/bin/openclaw gateway start
Restart=on-failure
RestartSec=10
Environment=ANTHROPIC_API_KEY=your-key
Environment=NODE_OPTIONS=--max-old-space-size=4096

[Install]
WantedBy=multi-user.target
```

```bash
systemctl daemon-reload
systemctl enable openclaw
systemctl start openclaw
systemctl status openclaw
```

### 6. 配置防火墙

```bash
# UFW 防火墙
apt install -y ufw
ufw allow 22/tcp    # SSH
ufw allow 18789/tcp # OpenClaw
ufw enable
ufw status
```

### 7. 配置域名 (可选)

```bash
# 安装 Nginx
apt install -y nginx

# 配置反向代理
nano /etc/nginx/sites-available/openclaw
```

```nginx
server {
    listen 80;
    server_name yourdomain.com;

    location / {
        proxy_pass http://127.0.0.1:18789;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

```bash
ln -s /etc/nginx/sites-available/openclaw /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx
```

### 8. 配置 SSL (Let's Encrypt)

```bash
apt install -y certbot python3-certbot-nginx
certbot --nginx -d yourdomain.com
```

## 备份策略

```bash
# 每日备份脚本
#!/bin/bash
tar -czf /backup/openclaw-$(date +%Y%m%d).tar.gz ~/.openclaw/
find /backup -mtime +7 -delete
```

## 监控

```bash
# 使用 Uptime Kuma
docker run -d --name uptime-kuma -p 3001:3001 -v uptime-kuma:/app/data louislam/uptime-kuma:1
```

## 更新 OpenClaw

```bash
npm update -g openclaw
systemctl restart openclaw
```

## 资源监控

```bash
# 安装 htop
apt install -y htop

# 监控资源
htop

# 监控日志
journalctl -u openclaw -f
```

## Oracle Cloud 免费 VPS

```bash
# 注册 Oracle Cloud 免费账户
# 创建 Always Free VM
# 选择 Ubuntu 22.04
# 配置 firewall rules: 18789 端口
```
