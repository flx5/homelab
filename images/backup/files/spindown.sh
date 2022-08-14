#!/bin/bash
set -e

rm /tmp/ssh_session_open || true

sleep 5m

# Session was reopened (for example by a borg prune after borg create), so do not stop disks
if test -f /tmp/ssh_session_open; then
   exit 0
fi


/usr/bin/umount /home/nasbackup/repository
/usr/sbin/vgchange -a n hdd
/usr/sbin/cryptdisks_stop md0_crypt
/usr/sbin/mdadm --stop /dev/md0

/usr/bin/sync

{%for disk in disks %}
  /usr/sbin/hdparm -y /dev/disk/by-id/{{disk}}
{% endfor %}
