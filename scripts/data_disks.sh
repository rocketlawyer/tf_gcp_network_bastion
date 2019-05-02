#!/bin/bash

HDFS_FILESYSTEM="ext4"
MOUNT_BASEDIR="/dfs"
COUNT=0
DEVICES=$(awk '/sd[b-z]/ { print $NF }' /proc/partitions)
OWNER_USER="root"
OWNER_GROUP="root"
DATE=`date +%Y-%m-%d`

if [ "${DEVICES}" ]; then
    for DEVICE in $DEVICES; do
      echo "Found ${DEVICE}"
      DEVICEPATH="/dev/${DEVICE}"
      blkid ${DEVICEPATH} | grep "${HDFS_FILESYSTEM}" >/dev/null 2>&1
      if [ $? == 0 ];
      then
        echo "Device already formatted as ${HDFS_FILESYSTEM}"
      else
        #GCP automatically format and mount secondary disks for Datanode servers.
        echo "Checking if device is mounted"
        MOUNTPOINT=$(grep ${DEVICE} /proc/mounts | awk '{ print $2 }')
        if [ ${MOUNTPOINT} ];
        then
          umount ${MOUNTPOINT}
        fi
        mkfs -t $HDFS_FILESYSTEM ${DEVICEPATH}
        MOUNTDIR="${MOUNT_BASEDIR}/data${COUNT}"
        if [ ! -d $MOUNTDIR ]; then
          mkdir -p $MOUNTDIR
        fi
        mount ${DEVICEPATH} ${MOUNTDIR}
        chmod 700 ${MOUNTDIR}
        let COUNT++
      fi
    done
    chown -R ${OWNER_USER}:${OWNER_GROUP} ${MOUNT_BASEDIR} && cp -pr /etc/fstab /etc/fstab-backup.${DATE} && echo "${DEVICEPATH}   ${MOUNTPOINT}   ext4   defaults,nofail   0 2" >> /etc/fstab
  else
    echo "WARNING - No Secondary devices found. Using /var/tmp/datanode as datanode dir"
fi
