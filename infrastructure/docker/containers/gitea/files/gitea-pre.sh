#!/bin/bash
set -e

mkdir -p "${dump_folder}"

docker container stop "${app_container}"
docker exec "${db_container}" mysqldump --single-transaction --default-character-set=utf8mb4 \
   -u "${user}" -p"${password}" "${database}" > "${dump_folder}/gitea.sql"
