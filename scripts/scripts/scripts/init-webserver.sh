#!/bin/bash
set -euo pipefail

echo "[1] 安装依赖"
sudo yum install -y nginx mariadb-server

echo "[2] 启动服务"
sudo systemctl enable --now nginx mariadb

echo "[3] 配置开机自启"
sudo systemctl enable nginx mariadb

echo "[4] 检查状态"
sudo systemctl is-active nginx
sudo systemctl is-active mariadb

echo "[5] 防火墙放行"
sudo firewall-cmd --permanent --add-service=http || true
sudo firewall-cmd --permanent --add-service=https || true
sudo firewall-cmd --reload || true

echo "init_done"
