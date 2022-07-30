#!/bin/bash
set -e

/usr/bin/umount /home/nasbackup/repository
/usr/sbin/vgchange -a n hdd
/usr/sbin/cryptdisks_stop md0_crypt
/usr/sbin/mdadm --stop /dev/md0

{%for disk in disks %}
  /usr/sbin/hdparm -y /dev/disk/by-id/{{disk}}
{% endfor %}
