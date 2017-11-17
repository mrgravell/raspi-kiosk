#!/bin/bash

#require a screen
export DISPLAY=:0

#blank the screen
echo "s activate"
xset s activate

#nb 2 seconds get added to this
IMG_TIME='6'

THIS_PATH='/home/pi/kiosk'
USB_PATH='/mnt/usb'
CLONE_PATH='/home/pi/kiosk/usb_clone'

#begin infinite loop
while true
do

#check if usb contains files
files=$(shopt -s nullglob dotglob; echo ${USB_PATH}/*)
if (( ${#files} ))
then
  echo "contains files"

  #hide screensaver and show loadings image
  echo "s reset"
  xset s reset
  feh --hide-pointer -x ${THIS_PATH}/loading.jpg &

  #clear out crap from usb so we don't have to copy it
  echo "deleting crap from usb"
  rm -r ${USB_PATH}/System\ Volume\ Information
  rm -r ${USB_PATH}/.??*

  #check for diff
  echo "check for differences ignoring .gitignore"
  OUTPUT1="$(diff -r -x '.gitignore' ${USB_PATH}/ ${CLONE_PATH}/ | grep ${USB_PATH}/ | awk '{print $4}')"
  OUTPUT2="$(diff -r -x '.gitignore' ${CLONE_PATH}/ ${USB_PATH}/ | grep ${CLONE_PATH}/ | awk '{print $4}')"
  OUTPUT=${OUTPUT1}${OUTPUT2}
  if [[ -z "${OUTPUT// }" ]] || [[ -z "${OUTPUT// }" ]]
  then
    echo "no differences"
  else
    echo "got differences"
    #sync the local directory to the usb. delete local files if deleted from usb.
    echo "syncing usb to local folder"
    rsync -r -v --exclude '.gitignore' --delete ${USB_PATH}/ ${CLONE_PATH}
  fi

  #unmount the usb - no longer needed
  echo "unmounting usb"
  umount ${USB_PATH}

  #reactivate screensaver & kill loading image
  echo "s activate"
  xset s activate
  pkill feh

else
  echo "usb empty or unplugged"
fi

#now loop thorugh each
echo "enter play loop now"
FILES=${CLONE_PATH}/*
for f in $FILES
do
  #get extrnsion
  ext="${f##*.}"
  #convert to lowercase
  ext="${ext,,}"
  echo $ext
if [[ $ext = 'mov' || $ext = 'mp4' ]]
then
 echo "trying to play"
 omxplayer $f
fi
if [[ $ext = 'jpg' || $ext = 'jpeg' || $ext = 'png' ]]
then
  echo "trying to show image"
  feh --hide-pointer --full-screen $f &
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
