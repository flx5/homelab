#!/bin/bash
set -e

while ! grep -q -s "/home/nasbackup/repository" /proc/mounts; do
        sleep 10
done

/usr/sbin/spindown.sh
