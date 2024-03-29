#!/bin/bash
set -e

exit_code=0


export BORG_BASE_DIR=/mnt/borg/
LOG="/root/backup/backup.log"
HOST=`hostname`
export PATH="$PATH:/usr/sbin/"
LOCKDIR=/run/backup_lock/

#Bail if borg is already running, maybe previous run didn't finish
# see https://unix.stackexchange.com/a/48510
echo "Locking lockdir"
if ! mkdir $LOCKDIR
then
  echo "Already running"
  exit;
fi

##
## Write output to logfile
##

exec > >(tee -i $LOG)
exec 2>&1


echo "###### Starting backup on $(date) ######"


%{~ for hostname, host in hosts ~}
  echo "Prepare Backup for ${hostname}"
  # TODO Replace with actual known keys..
  ssh-keyscan ${host.address} >> ~/.ssh/known_hosts
  export DOCKER_HOST=ssh://${host.username}@${host.address}

  echo "Pre scripts for ${hostname}"
  %{~ for container, script in host.scripts ~}
    # Pre script for container ${container} on ${hostname}
    (
      set -e
      ${indent(6, script.pre)}
    ) || {
       echo "Pre script for container ${container} on ${hostname} failed."
       exit_code=1
    }
  %{~ endfor ~}

  # Snapshots are created after all containers have been stopped.
  # This is done to ensure that shared files are not at risk of being modified.

  # Create snapshot only for data disk.
  # TODO It would be better to let this be generated by the libvirt terraform scripts
  (
    set -e

    diskspec=$(virsh domblklist ${host.vm_name} --details | awk '/\s+[a-z]/ \
        { if ($3 == "vdb")
            option = "file=/mnt/vm/data/${host.vm_name}_snapshot.qcow2";
          else
            option = "snapshot=no";

          printf " --diskspec %s,%s", $3, option
        }'
    )

    virsh snapshot-create-as --domain ${host.vm_name} backup_snapshot --no-metadata \
        $diskspec \
        --disk-only --atomic

    mkdir -p /mnt/backup/source/libvirt/${host.vm_name}

    # The snapshot image is actually an overlay. So we backup from the base image.
    guestmount -a /mnt/vm/data/${host.vm_name}_data.qcow2 -m /dev/sda1 --ro /mnt/backup/source/libvirt/${host.vm_name}
  ) || {
    echo "Creating libvirt Snapshot for ${host.vm_name} failed."
    exit_code=1
  }

  echo "Creating LVM Snapshots"
  %{~ for lvm_device in host.lvm ~}
  (
    set -e
    lvcreate -L${lvm_device.snapshot_size} --snapshot -n ${lvm_device.lv}_snapshot /dev/${lvm_device.vg}/${lvm_device.lv}
    mkdir -p /mnt/backup/source/lvm/${lvm_device.vg}/${lvm_device.lv}
    mount -o ro /dev/${lvm_device.vg}/${lvm_device.lv}_snapshot /mnt/backup/source/lvm/${lvm_device.vg}/${lvm_device.lv}
  ) || {
    echo "Creating LVM Snapshot for ${lvm_device.vg}/${lvm_device.lv} with size ${lvm_device.snapshot_size} failed."
    exit_code=1
  }
  %{~ endfor ~}



  echo "Post scripts for ${hostname}"
  %{~ for container, script in host.scripts ~}
    echo "Post script for container ${container} on ${hostname}"
    (
      set -e
      ${indent(6, script.post)}
    ) || {
      echo "Post script for container ${container} on ${hostname} failed."
      exit_code=1
    }
  %{~ endfor ~}
%{~ endfor ~}

(
  mount /dev/backup1/borg /mnt/backup/target/
) || {
  echo "Mounting local borg repo failed"
  exit_code=1
}

%{ for borg in borg_repos }
  (
    set -e

    echo "Syncing backup files to ${borg.repository} ..."
    BORG_PASSPHRASE="${borg.passphrase}" ionice -c best-effort -n 7 borg create -v --stats       \
        ${borg.repository}::'{now:%Y-%m-%d_%H:%M}'                 \
        \
    %{ for hostname, host in hosts ~}
      %{ for container, script in host.scripts ~}
        %{~ for vm_folder in script.vm_folders ~}
           /mnt/backup/source/libvirt/${host.vm_name}/${ trimprefix(vm_folder, "/opt/containers/")} \
        %{~ endfor ~}
      %{ endfor ~}
    %{~ endfor ~}
    ${ dump_folder } \
    /mnt/backup/source/lvm/

    BORG_PASSPHRASE="${borg.passphrase}" ionice -c best-effort -n 7 borg prune -v ${borg.repository} \
      --stats \
      --keep-daily=7 \
      --keep-weekly=4 \
      --keep-monthly=6
  ) || {
    echo "borg on repository ${borg.repository} failed"
    exit_code=1
  }
%{~ endfor ~}

(
  umount /dev/backup1/borg
) || {
  echo "Unmounting local borg repo failed"
  exit_code=1
}

%{~ for hostname, host in hosts ~}
  (
    set -e
    guestunmount /mnt/backup/source/libvirt/${host.vm_name}
    virsh blockcommit ${host.vm_name} vdb --active --verbose --pivot
    rm /mnt/vm/data/${host.vm_name}_snapshot.qcow2
  ) || {
    echo "Removing libvirt Snapshot for ${host.vm_name} failed."
    exit_code=1
  }

  echo "Removing LVM Snapshots"
  %{~ for lvm_device in host.lvm ~}
  (
    set -e
    umount /dev/${lvm_device.vg}/${lvm_device.lv}_snapshot
    lvremove -y /dev/${lvm_device.vg}/${lvm_device.lv}_snapshot
  ) || {
    echo "Removing LVM Snapshot for ${lvm_device.vg}/${lvm_device.lv} with size ${lvm_device.snapshot_size} failed."
    exit_code=1
  }
  %{~ endfor ~}
%{~ endfor ~}

echo "Unlocking lock dir..."
rmdir $LOCKDIR


echo "###### Finished backup on $(date) ######"

exit $exit_code