#!/bin/bash

SLEEP_TIME=3 #in seconds

while [ true ]; do

fswebcam -r 1280x720 /usb/cam/$(date -u +"%Y%m%d%H%M%S").jpg
fswebcam -r 1280x720 /var/www/html/latest.jpg
sleep $SLEEP_TIME;

done;


