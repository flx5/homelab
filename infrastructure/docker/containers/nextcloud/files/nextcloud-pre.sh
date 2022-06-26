#!/bin/bash
set -e
curl ${app}:8080/management.php?maintenance=true

mysqldump --single-transaction --default-character-set=utf8mb4 -h ${db_host} -u "${user}" -p"${password}" "${database}" > /scratch/nextcloud/nextcloud.sql