#!/bin/bash
set -e

curl -fsS --retry 3 "${healthcheck}/start"

# Copy the script to make sure it does not get modified during the run
tmpfile=$(mktemp /tmp/backup-script.XXXXXX)
cp "${backup_script}" "$tmpfile"
bash "$tmpfile"
rm "$tmpfile"

curl -fsS --retry 3 "${healthcheck}" > /dev/null
