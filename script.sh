echo "line 1";
#!/bin/bash
#wait for pi to wake up?
echo "line 2";

#require a screen
export DISPLAY=:0

#blank the screen
echo "s activate"
xset s activate

#nb 2 seconds get added to this
IMG_TIME='13'

THIS_PATH='/home/pi/kiosk'
USB_PATH='/mnt/usb'
CLONE_PATH='/home/pi/kiosk/usb_clone'


echo "line 3";

