#!/bin/bash
folders_backup=("/etc" "/home")
dest="/backup"
date=`date -I`
#remove old backup file
time=7
line="--------------------------------"
echo "Remove old backup files"
echo $line
for i in $(find $dest -iname "*.tar.xz" -type f -mtime +$time -print)
do
    rm -f $i
    if [ $? -eq 0 ]; then
        echo "Remove $i successfully"
    else
        echo "Remove $i failed"
    fi
done
echo
#ls -lh $dest
#backup folders
echo "Backup folders"
echo $line
for i in ${folders_backup[@]}
do
    tar -PcJf $dest/$i-$date.tar.xz $i
    if [ $? -eq 0 ]; then
        echo "The $i has been backed up sucessfull"
    else
        echo "Backup $i directory failed"
    fi
done
