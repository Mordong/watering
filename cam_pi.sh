#!/bin/bash

SLEEP_TIME=240 #in seconds

while [ true ]; do

raspistill -w 1280 -h 720 -e jpg -o /usb/cam/$(date -u +"%Y%m%d%H%M%S").jpg
raspistill -w 1280 -h 720 -e jpg -o /var/www/html/latest.jpg
sleep $SLEEP_TIME;

done;


