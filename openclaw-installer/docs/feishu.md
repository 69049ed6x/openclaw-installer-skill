# OpenClaw 飞书部署指南

## Sources (this file)

Primary source used to verify the Feishu channel setup steps and core commands:
- OpenClaw official Feishu docs (zh-CN): https://docs.openclaw.ai/zh-CN/channels/feishu

---

## 飞书应用创建

### 1. 创建应用

1. 访问 [飞书开放平台](https://open.feishu.cn/)
2. 使用飞书账号登录
3. 点击"创建应用" → 输入应用名称 → 创建
4. 获取 **App ID** 和 **App Secret**

### 2. 配置权限

进入应用 → 权限管理 → 添加以下权限：
- `im:message:send_as_bot` - 发送消息
- `im:message:send_as_bot` - 接收消息
- `im:chat:chat:readonly` - 读取聊天信息
- `im:chat:chat:create` - 创建群聊
- `contact:user.base:readonly` - 读取用户基本信息

### 3. 发布版本

1. 点击"发布" → 创建版本 → 填写版本号和说明
2. 提交审核 → 等待审核通过

## OpenClaw 配置

### 方法一：插件方式 (推荐)

```bash
# 安装飞书插件
openclaw plugins install feishu

# 配置 App ID 和 Secret
openclaw config set channels.feishu.enabled true
openclaw config set channels.feishu.appId "cli_xxxxxxxxxxxxxx"
openclaw config set channels.feishu.appSecret "your-app-secret"

# 重启网关
openclaw gateway restart
```

### 方法二：独立桥接 (更稳定)

```bash
# 安装独立桥接
npm install -g feishu-openclaw

# 配置
export FEISHU_APP_ID="cli_xxxxxxxxxxxxxx"
export FEISHU_APP_SECRET="your-secret"
export OPENCLAW_WS_URL="ws://localhost:18789"

# 启动桥接服务
feishu-openclaw
```

## Webhook 配置

### 创建机器人

1. 在飞书群聊中添加机器人
2. 选择"自定义机器人"
3. 获取 Webhook 地址

### 配置 Webhook

```bash
# 配置 Webhook URL
openclaw config set channels.feishu.webhookUrl "https://open.feishu.cn/open-apis/bot/v2/hook/xxx"
```

## 事件订阅配置

### 获取encrypt_key (可选)

如果启用加密：
1. 在应用配置页面 → 事件订阅 → 编辑
2. 启用"订阅 Encrypt Key"
3. 获取encrypt_key

### 配置回调地址

1. 在飞书开放平台配置事件回调URL
2. 验证方式：飞书会发送GET请求验证
3. 订阅事件：
   - `im.message.receive_v1` - 接收消息
   - `im.chat.member.bot.version_created_v1` - 成员变化

## 常见问题

### 1. 消息发送失败

```bash
# 检查配置
openclaw config get channels.feishu

# 检查日志
openclaw logs --follow | Select-String feishu
```

### 2. App Secret 错误

- 确认 App Secret 正确
- 确认应用已发布

### 3. 权限不足

- 检查应用权限是否包含所需权限
- 确认应用已发布

### 4. 网络问题

- 确认服务器可访问飞书API
- 检查防火墙端口

## 完整配置示例

```json
{
  "channels": {
    "feishu": {
      "enabled": true,
      "appId": "cli_xxxxxxxxxxxxxx",
      "appSecret": "your-secret",
      "encryptKey": "optional-encrypt-key",
      "webhookUrl": "optional-webhook-url",
      "botName": "OpenClaw",
      "mentionOnly": false,
      "autoReply": true
    }
  }
}
```

## 验证配置

```bash
# 测试飞书连接
openclaw channels status feishu

# 发送测试消息
openclaw message send --channel feishu --to "群聊ID" --message "Hello"
```

## 高级功能

### 图片消息

```javascript
// 在 skill 中发送图片
await channel.sendImage({
  image_path: "/path/to/image.png"
})
```

### 富文本消息

```javascript
await channel.sendMessage({
  msg_type: "post",
  content: {
    post: {
      zh_cn: {
        title: "标题",
        content: [[{ "tag": "text", "content": "内容" }]]
      }
    }
  }
})
```

### 卡片消息

```javascript
await channel.sendCard({
  header: { title: { tag: "plain_text", content: "标题" } },
  elements: [{ tag: "markdown", content: "**内容**" }]
})
```

## 相关资源

- [OpenClaw 飞书文档](https://docs.openclaw.ai/zh-CN/channels/feishu)
- [飞书开放平台](https://open.feishu.cn/)
- [AlexAnys/openclaw-feishu](https://github.com/AlexAnys/openclaw-feishu)
