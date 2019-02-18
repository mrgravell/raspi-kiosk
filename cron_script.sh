#!/bin/bash
#wait for pi to wake up?
sleep 40

#require a screen
export DISPLAY=:0

#blank the screen
echo "s activate"
xset s activate

#nb 2 seconds get added to this
IMG_TIME='18'

THIS_PATH='/home/pi/kiosk'
USB_PATH='/mnt/usb'
CLONE_PATH='/home/pi/kiosk/google_drive'

#begin infinite loop
while true
do

#now loop through each
echo "enter play loop now"
FILES=${CLONE_PATH}/*
for f in $FILES
do
  #get extension
  ext="${f##*.}"
  #convert to lowercase
  ext="${ext,,}"
  echo $ext
if [[ $ext = 'mov' || $ext = 'mp4'  || $ext = 'MOV'  || $ext = 'MP4' ]]
then
 #just in case first one didn't register at startup
 echo "trying to play"
 omxplayer "${f}"
fi
if [[ $ext = 'jpg' || $ext = 'jpeg' || $ext = 'png'  || $ext = 'JPG'  || $ext = 'JPEG'  || $ext = 'PNG' ]]
then
  echo "trying to show image"
#  feh --hide-pointer --full-screen --zoom fill -g 1820x720 $f &
  feh --hide-pointer --full-screen --zoom fill "{$f}" &
  sleep 1
  echo "s reset"
  xset s reset
  sleep $IMG_TIME
  echo "s activate"
  xset s activate
  sleep 1
  pkill feh
fi
done
echo "end of loop"
#end infinite loop
done
