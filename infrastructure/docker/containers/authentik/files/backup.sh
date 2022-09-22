mkdir -p "${dump_folder}"

docker container stop "${app_container}"
docker exec "${db_container}" PGPASSWORD="${password}" pg_dump -U "${user}" "${database}" > "${dump_folder}/authentik.sql"
