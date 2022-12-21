#!/bin/bash
#rm -rf dump_s905w
mkdir dump_s905w
cd dump_s905w

../bin/update identify 7

#AmlUsbIdentifyHost
#This firmware version is 2-4-0-0-1-0-0
#Need Password...Password check NG

#../bin/update password ../usb_password/password.bin

#Setting PWD..Pwd returned 16

#./bin/update identify 7

echo "Dump BootRom 0xD9040000"

../bin/amlogic-usbdl s905w ../payloads/s905/bin/memdump_BL1.bin s905w_BL1.bin


