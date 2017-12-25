#!/bin/bash
#Usage:CPU_Usage_alert.bash
## Collect Real Time CPU Usage 
## DATE: 26 Dec 2017
## Created By: Krishna Sharma
#CPU_USAGE=$(top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk '{ print $8 }' | cut -c1-2) 
CPU_USAGE=$(top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F, '{ print $4 }' |tr -d " " |cut -d"." -f1)
#DATE1=$(date "+%F-%H_%M")
if [[ $CPU_USAGE -le 10 ]] 
then 
	DATE=$(date "+%F %H:%M:%S")
	CPU_USAGE1="$DATE CPU: $CPU_USAGE" 
	echo "CRITICAL $CPU_USAGE1% Idle"
	echo "CRITICAL $CPU_USAGE1% Idle" >> /opt/cpusage.out 
	cat /opt/cpusage.out |tail -5 > /tmp/cpusage.tmp 
	mail -s "CPU Utilization of `hostname`" EmailAddr@domain.com < /tmp/cpusage.tmp 
elif [[ $CPU_USAGE -ge 10 ]] && [[ $CPU_USAGE -le 30 ]]
then
	DATE=$(date "+%F %H:%M:%S") 
	CPU_USAGE1="$DATE CPU: $CPU_USAGE" 
	echo "WARNING $CPU_USAGE1% Idle"
	echo "WARNING $CPU_USAGE1% Idle" >> /opt/cpusage.out 
	cat /opt/cpusage.out |tail -5 > /tmp/cpusage.tmp 
	mail -s "CPU Utilization of `hostname`" EmailAddr@domain.com  < /tmp/cpusage.tmp 
else 
	DATE=$(date "+%F %H:%M:%S") 
	CPU_USAGE1="$DATE CPU: $CPU_USAGE"
	echo "OK $CPU_USAGE1% Idle" 
	echo "OK $CPU_USAGE1% Idle" >> /opt/cpusage.out 
fi
