#!/bin/bash

## Functions

function ShowLastActionResult
{
  echo ""
  echo "$(tput setaf 3)"
  echo "╔════════════════════════════════════════════════════════════════"
  echo "║ $(tput sgr 0)Last action result : $LAST_RESULT $(tput setaf 3)"
  echo "╚════════════════════════════════════════════════════════════════$(tput sgr 0)"
}

function RecStart
{
read -p "$(tput setaf 2)USB camera - 1 or PI camera - 2 : $(tput sgr 0)" cam_ch

case $cam_ch in
	1) CAM_SH=cam.sh;;
	2) CAM_SH=cam_pi.sh;;
	*) ;;
esac

screen -dmS REC /scripts/cam.sh &
LAST_RESULT="Recording started"
}

function CheckScr
{
LAST_RESULT=`screen -ls`
}

function RecConnect
{
screen -x REC
LAST_RESULT="Connected/disconnected from REC session"
}

function WatConnect
{
screen -x WAT
LAST_RESULT="Connected/disconnected from REC session"
}

function RenConv
{
CAM_DIR=/usb/cam
TARGET_DIR=/usb/work

x=1;  
for i in $CAM_DIR/*.jpg;  
do counter=$(printf %05d $x);  
echo "Moving $i to $TARGET_DIR/img"$counter".jpg"
mv $i $TARGET_DIR/img"$counter".jpg
x=$(($x+1));
done;
avconv -f image2 -r 30 -i /usb/work/img%05d.jpg -c:v libx264 -r 30 /usb/video/$(date -u +"%Y%m%d_%H_%M")_out.mp4
LAST_RESULT="Images moved to /usb/work , output file in /usb/video"
}

function CleanUp
{
rm -rf /usb/cam/*
rm -rf /usb/work/*
rm -rf /usb/video/*
LAST_RESULT="/usb directories cleaned"
}

function Watering
{
screen -dmS WAT /scripts/watering.sh &
LAST_RESULT="Watering started"
}

## Menus
function MainMenu
{
  echo "$(tput bold) $(tput clear)"
  echo "╔══════════════════════╗"
  echo "║      Main Menu       ║"
  echo "╚══════════════════════╝"
  echo "$(tput sgr 0)"
  echo "$(tput setaf 2)Please choose your action:$(tput sgr 0)"
  echo "1 - start recording"
  echo "2 - check screened sessions"
  echo "3 - connect to REC session"
  echo "4 - rename and convert recorded files"
  echo "5 - clean up all directories"
  echo "6 - start watering"
  echo "7 - connect to WAT session"
  
  echo "0 - exit"
  echo ""
}

### Main script body ###
while true; do

MainMenu

ShowLastActionResult
  
  read -p "Please choose your action : " act_ch

  case $act_ch in
	  0) echo "$(tput setaf 2)$(tput bold)Fucked it up and fuck it down!!! $(tput sgr 0)"; exit 0;;
	  1) RecStart;;
	  2) CheckScr;;
	  3) RecConnect;;
	  4) RenConv;;
	  5) CleanUp;;
	  6) Watering;;
	  7) WatConnect;;

	  *) ;;
	esac

done;

exit 0;

