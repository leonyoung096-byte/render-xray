#!/bin/sh
set -e
# Railway 注入 PORT；TLS 由 Railway 边缘终止，容器内只跑明文 WS。
PORT="${PORT:-8080}"
WS_PATH="${WS_PATH:-/ws}"
if [ -z "$UUID" ]; then
  echo "ERROR: UUID env var is required (set it in Railway Variables, do not commit it)" >&2
  exit 1
fi
cat > /app/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [{ "id": "${UUID}", "flow": "" }],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "${WS_PATH}" }
      },
      "sniffing": { "enabled": true, "destOverride": ["http", "tls", "quic"] }
    }
  ],
  "outbounds": [
    { "protocol": "freedom", "tag": "direct" },
    { "protocol": "blackhole", "tag": "block" }
  ]
}
EOF
exec /app/xray run -config /app/config.json
