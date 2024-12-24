# [amlogic-usbdl](https://github.com/frederic/amlogic-usbdl) : unsigned code loader for Amlogic bootrom
* This vulnerability was identified, and tools were created for it by Frederic and Raxone added support for the S905,S905x,S905w chipset, as well as scripts and other necessary components.
*Update script 28.11.2023
*add extract aeskey,password,salt

add support for s905,s905x,s905x-h,s905w

add support usb password

mod amlogic-usbdl.c #check usb password stop

add scripts

* How to

git clone https://github.com/Raxone/amlogic-usbdl_s905_s905x_s905w.git

cd amlogic-usbdl_s905_s905x_s905w

./start.sh        (reboot device in Bootrom(BL1) and start menu)

1) S905 Dump BL1 
2) S905 Dump Efuse 
3) S905X-H Dump BL1 
4) S905X-H Dump Efuse
5) S905W Dump BL1
6) S905W Dump EFuse
Please enter a menu option and enter or x to exit. 


## Disclaimer
You will be solely responsible for any damage caused to your hardware/software/warranty/data/cat/etc...

## Description
Amlogic bootrom supports booting from USB. This method of boot requires an USB host to send a signed bootloader to the bootrom via USB port.

This tool exploits a [vulnerability](https://fredericb.info/2021/02/amlogic-usbdl-unsigned-code-loader-for-amlogic-bootrom.html) in the USB download mode to load and run unsigned code in Secure World.

## Supported targets #Tested
* s905      *Minix Neo U1
* s905x-h   *Mi Box S (MDZ-22-AB) #need maskrom
* s905w     *x96 mini

## Usage
```shell
$ ./amlogic-usbdl <target_name> <input_file> [<output_file>]
	target_name: s905 s905x-h s905w
	input_file: payload binary to load and execute (max size 65280 bytes)
	output_file: file to write data returned by payload
```

## Payloads
Payloads are raw binary AArch64 executables. Some are provided in directory **payloads/**.

## License
Please see [LICENSE](/LICENSE).
