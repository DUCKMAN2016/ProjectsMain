#!/bin/bash

# List u-nas
echo "Contents of /mnt/nas on u-nas:"
ssh duck@192.168.3.126 'ls -la /mnt/nas'

# List dk
echo "Contents of /mnt/nas-x on dk-nas:"
ssh duck@192.168.3.160 'ls -la /mnt/nas-x'
