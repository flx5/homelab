#!/bin/bash
set -e

echo 'OPEN' > /tmp/ssh_session_open

/usr/sbin/mdadm --assemble /dev/md0
/usr/sbin/cryptdisks_start md0_crypt
/usr/sbin/vgchange -a y hdd
/usr/bin/mount /home/nasbackup/repository
