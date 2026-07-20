#!/bin/bash
set -euo pipefail

DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="/data/backups/mysql"
DB_HOST="${DB_HOST:-127.0.0.1}"
DB_USER="${DB_USER:-root}"
DB_PASS="${DB_PASS:-}"
DB_NAME="${DB_NAME:-wordpress}"
RETENTION_DAYS="${RETENTION_DAYS:-7}"

mkdir -p "$BACKUP_DIR"

if [ -n "$DB_PASS" ]; then
  MYSQL="mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS""
  MYSQLDUMP="mysqldump -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS""
else
  MYSQL="mysql -h"$DB_HOST" -u"$DB_USER""
  MYSQLDUMP="mysqldump -h"$DB_HOST" -u"$DB_USER""
fi

$MYSQL -e "SELECT 1" >/dev/null

$MYSQLDUMP "$DB_NAME" | gzip > "$BACKUP_DIR/${DB_NAME}-${DATE}.sql.gz"

find "$BACKUP_DIR" -type f -name "*.sql.gz" -mtime +$RETENTION_DAYS -delete
