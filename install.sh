#!/bin/bash

sudo ln -s `readlink -f bin/s0enow` /usr/local/sbin/s0enow
sudo ln -s `readlink -f sync/s0enowSync.sh` /usr/local/sbin/s0enowSync.sh
sudo ln -s `readlink -f sync/wait2time.sh` /usr/local/sbin/wait2time.sh
sudo cp `readlink -f bin/s0enow.init` /etc/init.d/s0enow
sudo cp bin/s0enow.cfg /etc/
