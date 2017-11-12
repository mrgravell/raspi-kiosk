#!/bin/bash
echo "starting infinite loop"
echo "Press [CTRL+C] to stop.."
while true
do
  #count video files in dir
  shopt -s nullglob

  for ext in mp4 MP4 mov MOV
  do
    files=( /home/pi/kiosk/usb_clone/*."$ext" )
    printf 'number of %s files: %d\n' "$ext" "${#files[@]}"

#    for f in a b c
#    do
#    echo "poop"
#    done
    # now we can loop over all the files having the current extension
    for f in "${files[@]}"
    do
#    for f in a b c; do
     export DISPLAY=:0 ; omxplayer ${f}
    done

  done
  #loop through
	sleep 1
done
