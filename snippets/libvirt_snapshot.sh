DISKSPEC=$(virsh domblklist docker_web --details | awk '/\s+[a-z]/ \
    { if ($3 == "vdb")
        option = "file=/mnt/vm/data/docker_web_snapshot.qcow2"; 
      else 
        option = "snapshot=no"; 
        
      printf " --diskspec %s,%s", $3, option 
    }'
)

virsh snapshot-create-as --domain docker_web backup_snapshot --no-metadata \
    $DISKSPEC \
    --disk-only --atomic 
    
guestmount -a /mnt/vm/data/docker_web_data.qcow2 -m /dev/sda1 --ro /mnt/tmp/

# RUN BACKUP HERE

guestumount /mnt/tmp

# Remove snapshot
virsh blockcommit docker_web vdb --active --verbose --pivot

rm /mnt/vm/data/docker_web_snapshot.qcow2
