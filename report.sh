#!/bin/bash
ram=`free -h | grep "Mem:" | awk '{print $3}'`
totalram=`free -h | grep "Mem:" | awk '{print $2}'`
swap=`free -h | grep "Swap:" | awk '{print $3}'`
cpu=`cat /proc/stat | awk '/cpu/{printf("%.2f%\n"), ($2+$4)*100/($2+$4+$5)}' |  awk '{print $0}' | head -1`
hostname=`hostname`

echo "----------------------------------$hostname------------------------------------"
date
echo "MEMORY: $ram/$totalram"
echo "SWAP: $swap"
echo "CPU: $cpu"
echo "DISK: "
df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $3"/"$2" "$5 " " $1 }'
