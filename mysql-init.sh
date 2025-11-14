#!/bin/bash
DB_NAME=${DB_NAME:-hospital_db}
DB_USER=${DB_USER:-hospital_user}
DB_PASS=${DB_PASS:-Hospital@123}

# If DB already exists, exit
mysql -u root -e "USE ${DB_NAME}" 2>/dev/null && exit 0

# Create DB and user
mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
mysql -u root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Import schema if exists
if [ -f /tmp/hospital.sql ]; then
  mysql --database=${DB_NAME} -u root < /tmp/hospital.sql || true
fi
