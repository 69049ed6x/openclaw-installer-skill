# OpenClaw Docker 部署指南

## Sources (this file)

Primary source used to verify Docker deployment steps:
- OpenClaw official Docker docs: https://docs.openclaw.ai/install/docker
- Quick start command: `docker-setup.sh` (documented in the same page)

---

## 快速开始

```bash
# 方式一：直接运行
docker run -d \
  --name openclaw \
  -p 18789:18789 \
  -e ANTHROPIC_API_KEY="your-api-key" \
  -v openclaw-data:/root/.openclaw \
  openclaw/openclaw:latest

# 方式二：Docker Compose
curl -O https://raw.githubusercontent.com/openclaw/openclaw/main/docker-compose.yml
docker-compose up -d
```

## 环境变量

| 变量 | 必填 | 说明 |
|------|------|------|
| `ANTHROPIC_API_KEY` | 是 | Anthropic API Key |
| `OPENAI_API_KEY` | 否 | OpenAI 兼容 API |
| `OPENCLAW_GATEWAY_TOKEN` | 否 | 网关认证 Token |
| `AUTH_PASSWORD` | 否 | Web UI 密码 |

## Docker Compose 完整配置

```yaml
version: '3.8'
services:
  openclaw:
    image: openclaw/openclaw:latest
    container_name: openclaw
    ports:
      - "18789:18789"
    environment:
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - OPENCLAW_GATEWAY_TOKEN=your-secure-token
      - AUTH_PASSWORD=your-password
    volumes:
      - ./workspace:/workspace
      - openclaw-config:/root/.openclaw
    restart: unless-stopped
    stdin_open: true
    tty: true

volumes:
  openclaw-config:
```

## 自定义构建

```dockerfile
FROM openclaw/openclaw:latest

# 安装额外依赖
RUN npm install -g @openclaw/skill-name

# 复制自定义配置
COPY config.json /root/.openclaw/config.json

ENTRYPOINT ["openclaw"]
CMD ["gateway", "start"]
```

## 带 GPU 支持

```bash
# NVIDIA GPU
docker run -d \
  --gpus all \
  --name openclaw-gpu \
  -e ANTHROPIC_API_KEY="your-key" \
  openclaw/openclaw:latest
```

## 持久化配置

```bash
# 备份配置
docker cp openclaw:/root/.openclaw/config.json ./backup/

# 恢复配置
docker cp ./backup/config.json openclaw:/root/.openclaw/config.json

# 重启生效
docker restart openclaw
```

## 常用命令

```bash
# 查看日志
docker logs -f openclaw

# 进入容器
docker exec -it openclaw bash

# 查看状态
docker exec openclaw openclaw status

# 更新版本
docker pull openclaw/openclaw:latest
docker restart openclaw
```

## 问题排查

- 端口冲突：`docker ps` 检查 18789 端口
- 权限问题：使用 `--user $(id -u):$(id -g)`
- 日志查看：`docker logs openclaw 2>&1`
