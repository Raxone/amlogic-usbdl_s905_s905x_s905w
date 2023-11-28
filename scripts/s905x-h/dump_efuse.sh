#!/bin/bash

mkdir dump_s905x-h
cd dump_s905x-h

../bin/update identify 7

#AmlUsbIdentifyHost
#This firmware version is 2-4-0-0-1-0-0
#Need Password...Password check NG

../bin/update password ../usb_password/password.bin

#Setting PWD..Pwd returned 16

#./bin/update identify 7

echo "Dump SRAM 0xD9000000@14000"

../bin/amlogic-usbdl s905x-h ../payloads/s905x-h/bin/memdump_efuse.bin s905x-h_efuse.bin

echo "Dump Efuse"

dd if=s905x-h_efuse.bin bs=1 skip=80896 count=255 of=efuse.bin status=none

echo "Dump Password + Salt"

dd if=s905x-h_efuse.bin bs=1 skip=62728 count=20 of=password_salt.bin status=none

echo "Dump Password"

dd if=s905x-h_efuse.bin bs=1 skip=62728 count=16 of=password.bin status=none

echo "Dump AESKEY"

dd if=efuse.bin bs=1 skip=80 count=32 of=aeskey.bin status=none
