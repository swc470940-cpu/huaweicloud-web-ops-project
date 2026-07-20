#!/bin/bash
set -euo pipefail

FAIL=0

check() {
  local name="$1"
  local cmd="$2"
  if eval "$cmd" >/dev/null 2>&1; then
    echo "[OK] $name"
  else
    echo "[FAIL] $name"
    FAIL=$((FAIL+1))
  fi
}

check "nginx_process" "systemctl is-active --quiet nginx"
check "nginx_socket" "curl -fsS --max-time 3 http://127.0.0.1/ >/dev/null"
check "db_socket" "mysqladmin ping --silent"
check "disk_usage" "[ "$(df -P / | awk 'NR==2 {print $5}' | tr -d '%')" -lt 90 ]"

if [ "$FAIL" -gt 0 ]; then
  echo "health_check_failed=$FAIL"
  exit 1
fi

echo "health_check_passed"
