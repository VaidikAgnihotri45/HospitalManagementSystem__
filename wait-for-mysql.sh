#!/bin/bash
set -e
timeout=60
count=0
while [ $count -lt $timeout ]; do
  if mysqladmin ping &>/dev/null; then
    break
  fi
  count=$((count+1))
  sleep 1
done
/opt/app/mysql-init.sh || true
