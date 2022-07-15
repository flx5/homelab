for disk in {1..3}; do
   lvcreate -L10G --snapshot -n media_snapshot /dev/disk${disk}/media
   mkdir -p /mnt/backup/source/media/disk${disk}
   mount -o ro /dev/disk${disk}/media_snapshot /mnt/backup/source/media/disk${disk}
done
