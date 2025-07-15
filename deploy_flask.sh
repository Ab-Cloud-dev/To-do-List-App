#!/usr/bin/env bash
set -euo pipefail
APP_DIR="/home/ec2-user/app"
SERVICE_NAME="flask-app.service"
SERVICE_PATH="/etc/systemd/system/${SERVICE_NAME}"
USER="ec2-user"
GROUP="ec2-user"
PYTHON_BIN="$(which python3)"

echo "[*] Setting up app directory at $APP_DIR"
mkdir -p "$APP_DIR"

echo "[*] Creating Python venv"
cd "$APP_DIR"
$PYTHON_BIN -m venv venv

echo "[*] Installing requirements (if any)"
if [ -f requirements.txt ]; then
  source venv/bin/activate

fi

echo "[*] Writing systemd unit to $SERVICE_PATH"
sudo tee "$SERVICE_PATH" > /dev/null <<EOF
[Unit]
Description=Flask Application Service
After=network.target

[Service]
User=${USER}
Group=${GROUP}
WorkingDirectory=${APP_DIR}
Environment="PATH=${APP_DIR}/venv/bin"
ExecStart=${APP_DIR}/venv/bin/python3 ${APP_DIR}/app.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "[*] Reloading systemd and enabling service"
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl restart "$SERVICE_NAME"

echo "✅ Service '${SERVICE_NAME}' started. Use 'systemctl status ${SERVICE_NAME}' to check logs."
