#!/bin/bash
set -e

mkdir -p /scratch/nextcloud

docker container stop "${app_container}"
docker exec "${db_container}" mysqldump --single-transaction --default-character-set=utf8mb4 -u "${user}" -p"${password}" "${database}" > /scratch/nextcloud/nextcloud.sql