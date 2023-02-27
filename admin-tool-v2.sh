#!/bin/bash
header="

░█████╗░██████╗░███╗░░░███╗██╗███╗░░██╗  ████████╗░█████╗░░█████╗░██╗░░░░░
██╔══██╗██╔══██╗████╗░████║██║████╗░██║  ╚══██╔══╝██╔══██╗██╔══██╗██║░░░░░
███████║██║░░██║██╔████╔██║██║██╔██╗██║  ░░░██║░░░██║░░██║██║░░██║██║░░░░░
██╔══██║██║░░██║██║╚██╔╝██║██║██║╚████║  ░░░██║░░░██║░░██║██║░░██║██║░░░░░
██║░░██║██████╔╝██║░╚═╝░██║██║██║░╚███║  ░░░██║░░░╚█████╔╝╚█████╔╝███████╗
╚═╝░░╚═╝╚═════╝░╚═╝░░░░░╚═╝╚═╝╚═╝░░╚══╝  ░░░╚═╝░░░░╚════╝░░╚════╝░╚══════╝
							
Follow me on Github: @vivi789
"
tmp=$(mktemp -t test.XXXXXX)
tmp2=$(mktemp -t test2.XXXXXX)
tmp3=$(mktemp -t test3.XXXXXX)
function check_top_cpu {
	ps -aux --sort=-pcpu | head -n 11 > $tmp
	dialog --title "Top CPU Resource Hog Processes" --textbox $tmp 20 150
}

function check_top_mem {
	ps -aux --sort=-pmem | head -n 11 > $tmp
	dialog --title "Top Memory Resource Hog Processes" --textbox $tmp 20 150
}

function check_top_swap {
	find /proc -maxdepth 2 -path "/proc/[0-9]*/status" -readable -exec awk -v FS=":" '{process[$1]=$2;sub(/^[ \t]+/,"",process[$1]);} END {if(process["VmSwap"] && process["VmSwap"] != "0 kB") printf "%10s %-30s %20s\n",process["Pid"],process["Name"],process["VmSwap"]}' '{}' \; | awk '{print $(NF-1),$0}' | sort -hr | cut -d " " -f2- | head -n 20 > $tmp
	dialog --title "Top Swap Resource Hog Processes" --textbox $tmp 20 100
}

function check_os {
	os=`cat /etc/os-release | grep -w "PRETTY_NAME" | awk -F '"' {'print $2'}`
	echo "OS: $os" > $tmp
	dialog --textbox $tmp 10 50
}

function check_disk {
	df -h | awk 'BEGIN {FS=" "; OFS=","} {print $1,$6,$5}'> $tmp3.csv
	mlr --icsv --opprint --barred cat $tmp3.csv > $tmp
	dialog --textbox $tmp 40 75
}

function check_mem {
	free -h | grep "Mem" | awk '{print $1","$3*100/$2"%"}' > $tmp3.csv
	free -h | grep "Swap" | awk '{print $1","$3*100/$2"%"}' >> $tmp3.csv
	mlr --icsv --opprint --barred cat $tmp3.csv > $tmp
	dialog --textbox $tmp 20 30
}

function check_internet_access {
	ping -c 1 google.com >& /dev/null
	if [ $? -eq 0 ]
	then
		echo "Check Internet access: OK" > $tmp
		echo -e "\nIPv4 Public: $(curl -s icanhazip.com)" >> $tmp
	else
		echo "Check Internet access: Fail" > $tmp
		echo -e "\nPlease try again"
	fi
	dialog --textbox $tmp 10 30
}


while [ 1 ]
do
	clear
	dialog --menu "$header" 30 80 20 1 "Top processes CPU usage" 2 "Top processes Memory usage" 3 "Top processes Swap usage" 4 "Check OS version" 5 "Check disk usage" 6 "Check memory usage" 7 "Check Internet connection" 0 "Exit" 2> $tmp2
	selection=$(cat $tmp2)
	case $selection in
		1) check_top_cpu;;
		2) check_top_mem;;
		3) check_top_swap;;
		4) check_os;;
		5) check_disk;;
		6) check_mem;;
		7) check_internet_access;;
		0) break;;
		*) break;;
	esac
done
rm -f $tmp
rm -f $tmp2
rm -f $tmp3
clear
