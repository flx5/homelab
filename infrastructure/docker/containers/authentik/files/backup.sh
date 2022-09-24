mkdir -p "${dump_folder}"

docker container stop "${app_container}"
docker exec -e 'PGPASSWORD=${password}' "${db_container}"  pg_dump -U "${user}" "${database}" > "${dump_folder}/authentik.sql"
