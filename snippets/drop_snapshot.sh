for disk in {1..3}; do
   umount /dev/disk${disk}/media_snapshot
   lvremove -y /dev/disk${disk}/media_snapshot
done
