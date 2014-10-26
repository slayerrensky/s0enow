#!/bin/bash

# call getVarFromFile variable file
function getVarFromFile {
  LINE=`cat $2 | grep ^"$1"`
  VALUE=$(echo $LINE | sed -e 's/'$1'[ ]*=[ ]*"\([a-zA-Z0-9//.\-]*\)"/\1/')
  echo "$VALUE"
}

SERVER=$(getVarFromFile "Server" /etc/s0enow.cfg)
USERNAME=$(getVarFromFile "User" /etc/s0enow.cfg)
PATHFOLDER=/usr/local/sbin/
DATAFOLDER=$(getVarFromFile "Datafolder" /etc/s0enow.cfg)
RFOLDER=$(getVarFromFile "Remoutedatafolder" /etc/s0enow.cfg)
REMOUTEDATAFOLDER=$USERNAME@$SERVER:$RFOLDER
HOUR=$(getVarFromFile "Hour" /etc/s0enow.cfg)
echo $HOUR
MINUTE=$(getVarFromFile "Minute" /etc/s0enow.cfg)
echo $MINUTE
function syncData {
  echo "send from "$DATAFOLDER" to "$REMOUTEDATAFOLDER
  rsync -av $DATAFOLDER $REMOUTEDATAFOLDER

  STATUS=$?
  i=0
  while [ $STATUS -ne 0 -a ${i} -lt 3 ]
  do 
    rsync -av $DATAFOLDER $REMOUTEDATAFOLDER
    STATUS=$?
    i=$(expr $i + 1)
    echo $i
  done 
  
  if [ $STATUS -eq 0 ] ;then
    DATUM=$(date '+%Y-%m-%d %H:%M:%S')
    DATEJMT=$(date '+%Y-%m-%d')
    echo "Sync Erfolgreich "$DATUM | ssh $USERNAME@$SERVER "cat >> "$DATAFOLDER"sync.txt"
    echo "Update "$DATAFOLDER"sync.txt"
    echo "Sync Erfolgreich "$DATUM >> $DATAFOLDER'sync.txt'
    echo "Syncronisation erfolgreich"
  fi
}


function connect {

  sudo ifup ppp0
  
  i=0
  ifplugstatus ppp0
  STATUS=$?
  while [ $STATUS -ne 2 -a ${i} -lt 5 ]
  do
    echo "not connected wait 5 sec"
    sleep 5
    ifplugstatus ppp0
    STATUS=$?
    echo "Status: "$STATUS
    i=$(expr $i + 1)
  done
  
  echo "connect to "$(ifquery ppp0)
  
  i=0
  ping -c 1 $SERVER
  while [ $? -ne 0 -a ${i} -lt 5 ]
  do
    echo "Ping nicht erfolgreich"
    sleep 5  
    i=$(expr $i + 1)
    ping -c 1 $SERVER  
  done
  if [ $i -ge 5 ] ;then
    CONNECTED=0
    echo "Can not connect to "$SERVER
  fi
  CONNECTED=1
  echo "ping erfolgreich zu "$SERVER
}

function updatedate {
  CONNECTED=0
  connect
  if [ $CONNECTED -eq 1 ] ;then
    sudo ntpdate pool.ntp.org
  fi
  sudo ifdown ppp0
}

sleep 20
updatedate

sudo /etc/init.d/s0enow start
while true; do
  # wait2time.sh 20 00 bedeutet ummer um 20:00 uhr
  # wait2time.sh -1 00 bedeutet zu jeder stunde um xx:00
  echo "Stunde="$HOUR" Minute="$MINUTE
  eval $PATHFOLDER"wait2time.sh "$HOUR" "$MINUTE 
  sleep 5
  CONNECTED=0
  connect
  if [ $CONNECTED -eq 1 ] ;then
    syncData
    sudo ntpdate pool.ntp.org
    if [ $? -eq 0 ] ;then
      echo "Time is up to date."
    else
      echo "Cant update Time."
    fi
  fi
  sudo ifdown ppp0
done
