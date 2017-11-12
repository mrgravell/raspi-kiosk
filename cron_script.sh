#!/bin/bash

# we'll need this at some point
#
# feh --hide-pointer -x -q -D 5 -B black -g 320x240 /path/to/pictures
#

#blank the screen
export DISPLAY=:0 ; xset s activate

cd /home/pi/kiosk
#delete bs dot files and system volume information
#rm /home/pi/kiosk/usb_clone/.??*
rm -r /mnt/usb/System\ Volume\ Information
rm -r /mnt/usb/.??*
#check if usb contains files
files=$(shopt -s nullglob dotglob; echo /mnt/usb/*)
if (( ${#files} ))
then
  echo "contains files"
  #check for diff
  OUTPUT1="$(diff -r /mnt/usb/ /home/pi/kiosk/usb_clone/ | grep /mnt/usb/ | awk '{print $4}')"
  OUTPUT2="$(diff -r /home/pi/kiosk/usb_clone/ /mnt/usb/ | grep /home/pi/kiosk/usb_clone/ | awk '{print $4}')"
  OUTPUT=${OUTPUT1}${OUTPUT2}
  if [[ -z "${OUTPUT// }" ]] || [[ -z "${OUTPUT// }" ]]
  then
    echo "no changes"

  SC_CODE="$(pidof play_script.sh | wc -w)"
  OM_CODE="$(pidof omxplayer.bin | wc -w)"
  CODE=$((${SC_CODE}+${OM_CODE}))
  echo "code is ${CODE}"
case ${CODE} in

0)  echo "Starting Script:"
    ./play_script.sh
    ;;
1)  echo "play_script.sh already running"
    ;;
esac

  else
    #first stop the play script if it is running
    echo "trying to kill play_script.sh and omxplayer"
    pkill feh
    pkill omxplayer.bin
    pkill play_script.sh
    echo "disable screensaver, show waiting image and continue execution"
    export DISPLAY=:0 ; xset s reset
    export DISPLAY=:0 ; feh --hide-pointer -x /home/pi/kiosk/loading.jpg &
    #sync the local directory to the usb. delete local files if deleted from usb.
    rsync -r -v --exclude '.gitignore' --delete /mnt/usb/ /home/pi/kiosk/usb_clone
    #now start the play script
    echo "enable screensaver, start play script"
    export DISPLAY=:0 ; xset s activate
    pkill feh
    ./play_script.sh
  fi
else
  echo "usb empty or unplugged"
fi
