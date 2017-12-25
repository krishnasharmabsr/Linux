#!/bin/bash
#Usage:Decimal_to_Binary.bash
#Created By:Krishna Sharma

echo -e "\n\e[1m\e[42mPlease Enter Number To Convert Into Binary Number\t:\t\e[0m\c"
read NUM
NAME=$(while [ $NUM != 0 ]
do
	RES=$(expr $NUM % 2)
	NUM=$(expr $NUM / 2)
	echo $RES
done)

echo -e "\n\e[1m\e[41mBINARY NUMBER IS\t\t\t\t\e[0m\t:\t\e[1m\e[6m$(echo $NAME|tr -d " " |rev)\e[0m"
