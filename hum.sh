#!/bin/bash

SLEEP_TIME=3 # timeout for check cycle in seconds
REPORT=watering_report.txt
C_START=`date -u +"%d/%m/%Y %H:%M:%S"`

declare -a control=(1 2 3 4) #number of pairs sensor/relay
declare -A SENSOR=([P1]=4 [P2]=17 [P3]=27 [P4]=22) #set GPIO numbers for sensors
declare -A RELAY=([P1]=18 [P2]=23 [P3]=24 [P4]=25) #set GPIO numbers for relays
declare -a GPIO=("${SENSOR[@]}" "${RELAY[@]}")
declare -A STATUS=([P1]=0 [P2]=0 [P3]=0 [P4]=0) #0 - dry, 1 - wet

function Report {

echo "Sensor : " ${SENSOR['P'$pair]} " and Relay : " ${RELAY['P'$pair]} >>$REPORT
echo "Pair: $pair - Status: ${STATUS['P'$pair]}" >>$REPORT

}

for portnum in "${GPIO[@]}"; do

if [ ! -e /sys/class/gpio/gpio$portnum ]; then echo $portnum > /sys/class/gpio/export; fi

done;

while [ true ]; do

	for pair in "${control[@]}"; do
	
	SENS=${SENSOR['P'$pair]}
	REL=${RELAY['P'$pair]}
	echo "in" > /sys/class/gpio/gpio$SENS/direction
	HUM=`cat /sys/class/gpio/gpio$SENS/value`

	if [ "$HUM" -eq 0 ]; then	# relay is on when humidity is big
	echo "out" > /sys/class/gpio/gpio$REL/direction
	echo 1 > /sys/class/gpio/gpio$REL/value
	STATUS['P'$pair]="Wet"	
		else
		echo "out" > /sys/class/gpio/gpio$REL/direction
		echo 0 > /sys/class/gpio/gpio$REL/value
		STATUS['P'$pair]="Dry"
	fi
Report;	
	done;
C_END=`date -u +"%d/%m/%Y %H:%M:%S"`
if [[ "${STATUS[@]}" =~ "Dry" ]]; then true; else echo "Started at   $C_START">>$REPORT&&echo "Completed at $C_END" >>$REPORT&&exit 0; fi

sleep $SLEEP_TIME;
>$REPORT

done;

exit 0

