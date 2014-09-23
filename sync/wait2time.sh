#!/bin/bash

time=$1

sleep_until(){
 s=$(($(date +%s --date "$*") - $(date +%s)))  # Übergebene Zeit - aktuelle Zeit, jeweils in Sekunden seit 1.1.1970
 if [ $s -ge 0 ]; then   # negative Zeitspanne ignorieren
   sleep $s;
 fi
}


if [ $1 -eq "-1" ]; then
  currentM=$(date '+%M')
  currentH=$(date '+%H')
  if [ $currentM -gt $2 ]; then
    if [ $currentH -eq 23 ]; then
      nextH=0
      s=$(($(date +%s --date "+1 day "$nextH":"$2) - $(date +%s)))
    else
      nextH=$(expr $currentH + 1)
      s=$(($(date +%s --date $nextH":"$2) - $(date +%s)))
    fi
  else
    nextH=$currentH
    s=$(($(date +%s --date $nextH":"$2) - $(date +%s)))
  fi 
else
  currentH=$(date '+%H')
  if [ $currentH -gt $1 ]; then
    s=$(($(date +%s --date "+1 day "$1":"$2) - $(date +%s)))
  else
    s=$(($(date +%s --date $1":"$2) - $(date +%s)))
  fi
fi

echo "Execute in "$s" sec"

if [ $s -ge 0 ]; then   # negative Zeitspanne ignorieren
   sleep $s;
fi


