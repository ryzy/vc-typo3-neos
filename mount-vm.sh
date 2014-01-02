#!/bin/bash

# VM IP address
IP=192.168.66.6

# Where the shared resource will be mounted
DIRECTORY='/Volumes/vc-typo3-www'

# Mount parameters
MOUNT_PARAMS='async,udp,vers=3,resvport,intr,rsize=32768,wsize=32768,soft'

if [ ! -d $DIRECTORY ]; then
  mkdir -p $DIRECTORY
fi

echo "Mounting directory from $IP to $DIRECTORY... Root privileges might be required."
sudo mount_nfs -o $MOUNT_PARAMS $IP:/var/www $DIRECTORY
echo "Mounted successfully."
