# OpenClaw Raspberry Pi 安装指南

## Sources (this file)

Primary source used to verify Raspberry Pi installation steps:
- OpenClaw official Raspberry Pi docs: https://docs.openclaw.ai/platforms/raspberry-pi

---

## Sources (this file)

Primary source used to verify Raspberry Pi hardware requirements and install steps:
- OpenClaw official Raspberry Pi platform docs: https://docs.openclaw.ai/platforms/raspberry-pi

---

## 硬件要求

- **Raspberry Pi**: 4B 或更新 (推荐 5)
- **RAM**: 4GB 最低, 8GB 推荐
- **存储**: 16GB+ microSD 卡
- **系统**: Raspberry Pi OS 64-bit (推荐)

## 系统准备

```bash
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装必要依赖
sudo apt install -y curl git build-essential
```

## Node.js 安装

```bash
# 方法一：使用 NodeSource (推荐)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# 验证
node --version  # v20.x.x
npm --version
```

## OpenClaw 安装

```bash
# 全局安装
sudo npm install -g openclaw

# 验证
openclaw --version
```

## 性能优化

### 增加 Swap

```bash
sudo dphys-swapfile swapoff
sudo sed -i 's/CONF_SWAPSIZE=.*/CONF_SWAPSIZE=2048/' /etc/dphys-swapfile
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
```

### 限制 Node.js 内存

```bash
# 在 ~/.bashrc 中添加
echo 'export NODE_OPTIONS="--max-old-space-size=1536"' >> ~/.bashrc
source ~/.bashrc
```

## 散热处理

```bash
# 安装散热片和风扇
# 或使用被动散热外壳
```

## 远程访问

###局域网访问

```bash
# 查看 IP 地址
hostname -I

# 开放端口
sudo ufw allow 18789/tcp
```

### Tailscale 远程访问

```bash
# 安装 Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# 启动
sudo tailscale up

# 配置 OpenClaw 使用 Tailscale
openclaw config set gateway.bind tailnet
sudo systemctl restart openclaw
```

## systemd 服务

```bash
sudo nano /etc/systemd/system/openclaw.service
```

```ini
[Unit]
Description=OpenClaw AI Assistant
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/.openclaw/workspace
Environment=NODE_OPTIONS=--max-old-space-size=1536
Environment=ANTHROPIC_API_KEY=your-key
ExecStart=/usr/bin/openclaw gateway start
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable openclaw
sudo systemctl start openclaw
```

## 常见问题

### 内存不足

- 增加 swap 到 2GB
- 使用更小的模型
- 减少并发任务

### 运行缓慢

- 使用外接 SSD 而非 SD 卡
- 增加内存限制
- 使用有线网络

### USB 设备权限

```bash
# 添加用户到 dialout 组
sudo usermod -a -G dialout pi
```
