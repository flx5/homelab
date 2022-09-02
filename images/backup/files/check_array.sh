#!/bin/bash
set -e

# TODO Remove debug output

echo "Spinning disks up for raid check"

/usr/sbin/spinup.sh

echo "Schedule raid check"
/usr/share/mdadm/checkarray --cron --all --idle --quiet

echo "Wait for raid check to start"

while [[ $(< /sys/block/md0/md/sync_action) != "check" ]]; do
  sleep 10s
done

echo "Wait for raid check to finish"

while [[ $(< /sys/block/md0/md/sync_action) != "idle" ]]; do
  sleep 5m
done

echo "Scheduling spindown"

/usr/sbin/spindown.sh

echo "Spindown result:"

cat /proc/mdstat
