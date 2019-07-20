#!/bin/bash
## service dicovery bash script for zabbix.
## written by Mohammadreza Miramou
service=$2	
discovery(){
echo "{"
echo '	"data":['
first=1

while read line 
do
	if [ "$first" != "0" ]
	then
		first=0
	else
		ELEMENT="{ \"{#SERVICE}\":\"$SERVICE\" },"
        	echo "$ELEMENT"
	fi
	SERVICE=$line
done <<< "`systemctl list-unit-files  --type=service | awk '{print $1}' | grep -v "UNIT" | sed '/^$/d' | sed -n '/.service$/p' | sed -e 's/.service$//g'`"

ELEMENT="{ \"{#SERVICE}\":\"$SERVICE\" }"
echo "$ELEMENT"
echo ']'
echo "}"
}
state(){
#service=$2	
status=`systemctl status "$service" | grep "Active" | tr -d '()' | awk -F ' '  '{print $2":"$3}'`
if [[ "$status" == "active:running" ]]
then 
	echo "UP"
elif  [[ "$status" == "active:exited" ]]
then
	echo "UP"
else
	echo "DOWN"
fi
}
case $1 in
"")
	discovery;;
"status")
	state;;
*)
	echo "you must run correct this script"
	exit 1
	;;
esac
