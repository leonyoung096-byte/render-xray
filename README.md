# Render Xray VLESS + WS + TLS

原理同 Railway 版：Render 给 `*.onrender.com` 自动配 TLS 证书、443 入口，
TLS 在 Render 边缘终止，容器内 Xray 只监听 Render 注入的 `$PORT`、
跑明文 WebSocket。客户端写 `security=tls` 是对的，对的是边缘那层 TLS。

## Render 里要填的变量（不要提交进仓库）

- `UUID`：VLESS 用户 ID，在 Render Environment 里填
- `WS_PATH`：例如 `/xxxxxxxxxxxxxxxx`，客户端 path 要一字不差

## 部署要点

- 类型：Web Service，来源：Public Git Repository（本仓库，公开、无密钥）
- 区域：Oregon（美国，出口为美国 IP）
- 计划：先用 Free 验证连通；Free 在 15 分钟无流量后休眠，
  下一次连接约需 30–60 秒唤醒，日常主力用建议升 Starter（约 $7/月，常驻不休眠）
- 环境变量：UUID、WS_PATH（见上），PORT 由 Render 自动注入，不要手动改
- 客户端链接格式（域名、UUID、path 替换后）：
  `vless://UUID@域名:443?encryption=none&security=tls&sni=域名&type=ws&host=域名&path=URL编码后的WS_PATH#Render-VLESS-WS-TLS`

注意：Render 出口是机房 IP，不是住宅 ISP IP。能做通用上网节点，
不能指望它像住宅 IP 那样被 Apple Intelligence / Siri 当成家庭宽带信任。
