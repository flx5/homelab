#!/bin/bash
set -e

mkdir -p /scratch/gitea

docker container stop "${app_container}"
docker exec "${db_container}" mysqldump --single-transaction --default-character-set=utf8mb4 -u "${user}" -p"${password}" "${database}" > /scratch/gitea/gitea.sql