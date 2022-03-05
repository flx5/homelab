#!/bin/bash

# TODO Base upon https://github.com/AmpereComputing/terraform-openstack-images/blob/master/fedora/fedora_atomic_image.sh

if [ -e  flatcar_production_qemu_image.img ]
then
   exit 0
fi

wget https://stable.release.flatcar-linux.net/amd64-usr/current/flatcar_production_qemu_image.img.bz2{,.sig}
gpg --verify flatcar_production_qemu_image.img.bz2.sig
bunzip2 flatcar_production_qemu_image.img.bz2
