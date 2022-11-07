#!/bin/bash
echo "
     )))
    (((
  +-----+
  |     |]
  `-----'  
___________
`---------'
"
echo "OS: $(cat /etc/os-release | grep -w "PRETTY_NAME" | cut -d "=" -f 2)"
#check network
if ping -c 1 -q google.com >& /dev/null
then
        echo "CHECK INTERNET: OK"
else
        echo "CHECK INTERNET: FAILED"
fi
echo "UPTIME: $(uptime | awk -F "," '{print $1}')"
echo "LOAD: $(uptime | awk -F ":" '{print $NF}')"
echo "RAM: $(free -h | grep -vE "total|Swap" | awk '{print $3"/"$2}')"
echo "SWAP: $(free -h | grep -vE "total|Mem" | awk '{print $3"/"$2}')"
echo "DISK:"
df -h | grep -vE '^Filesystem|tmpfs|cdrom|loop' | awk '{ print $3"/"$2" "$5 " " $1 }'
echo "INODE:"
df -hi | grep -vE "tmpfs|Filesystem|udev|boot|tmp" | awk {'print $3"/"$2"   "$5"   "$6'}
