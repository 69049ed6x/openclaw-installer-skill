# OpenClaw 故障排除速查

## Sources (this file)

Primary source used to verify the recommended diagnostic command ladder:
- OpenClaw official gateway troubleshooting runbook: https://docs.openclaw.ai/gateway/troubleshooting

---

## 快速诊断

```bash
# 一键诊断
openclaw doctor

# 详细诊断
openclaw doctor --verbose

# 查看状态
openclaw status

# 查看日志
openclaw logs --follow

# 深度检查
openclaw status --deep
```

## 常见问题速查

| 错误 | 原因 | 解决方案 |
|------|------|----------|
| `command not found` | PATH 未配置 | `source ~/.bashrc` 或重新安装 |
| `ANTHROPIC_API_KEY not set` | 未设置环境变量 | `export ANTHROPIC_API_KEY="..."` |
| `EACCES: permission denied` | 权限问题 | 使用 nvm 或修复 npm 目录权限 |
| `Node.js version too old` | Node 版本过低 | 更新到 v18+ |
| `API request failed` | API 密钥错误 | 检查密钥格式和余额 |
| `Port 18789 already in use` | 端口占用 | 杀死占用进程或换端口 |
| `Gateway start blocked` | 配置错误 | 设置 `gateway.mode=local` |

## 网关相关

### 网关无法启动

```bash
# 检查端口
netstat -tulpn | grep# 查看详细错误
openclaw gateway start 18789

 --verbose

# 重新配置
openclaw configure
```

### 服务模式问题

```json
// 设置为本地模式
{
  "gateway": {
    "mode": "local"
  }
}
```

### Token 不匹配

```bash
# 重置 Token
openclaw gateway token reset

# 或手动设置
openclaw config set gateway.auth.token "new-token"
```

## 通道问题

### Telegram

- Bot Token 错误
- 未设置 inline keyboard 权限
- 群组中未 @bot

### Discord

- Token 过期
- Intent 权限不足
- Channel ID 错误

### WhatsApp

- QR Code 过期（重新扫描）
- Phone Number 格式错误

### 飞书

- App ID/Secret 错误
- 应用未发布
- 权限不足

## 模型相关

### API 密钥问题

```bash
# 测试 API 连接
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"claude-sonnet-4-20250514","max_tokens":10,"messages":[{"role":"user","content":"Hi"}]}'
```

### 模型不支持

```bash
# 列出可用模型
openclaw models list

# 设置默认模型
openclaw config set agents.defaults.model.primary "claude-sonnet-4-20250514"
```

## 性能问题

### 内存不足

```bash
# 限制 Node.js 内存
export NODE_OPTIONS="--max-old-space-size=2048"

# 或在配置中设置
{
  "agents": {
    "defaults": {
      "model": {
        "maxTokens": 4096
      }
    }
  }
}
```

### 响应慢

- 检查网络延迟
- 减少上下文长度
- 使用更小的模型

## 数据问题

### 清理缓存

```bash
# 清理 npm 缓存
npm cache clean --force

# 清理 OpenClaw 缓存
rm -rf ~/.openclaw/cache/*

# 完全重置
rm -rf ~/.openclaw
openclaw onboard
```

### 备份与恢复

```bash
# 备份
tar -czf openclaw-backup.tar.gz ~/.openclaw/

# 恢复
tar -xzf openclaw-backup.tar.gz -C ~/
```

## 获取帮助

```bash
# 生成调试报告
openclaw debug-report > ~/openclaw-debug.txt

# 检查更新
openclaw update check

# 查看版本
openclaw --version
```

## 常用命令汇总

```bash
# 基础
openclaw --version          # 版本
openclaw status             # 状态
openclaw doctor             # 诊断
openclaw configure          # 配置

# 网关
openclaw gateway start      # 启动
openclaw gateway stop       # 停止
openclaw gateway restart    # 重启
openclaw gateway status    # 状态

# 通道
openclaw channels list      # 通道列表
openclaw channels status    # 通道状态

# 模型
openclaw models list        # 模型列表

# 日志
openclaw logs              # 查看日志
openclaw logs --follow     # 实时日志
```
