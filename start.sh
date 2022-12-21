#!/bin/bash


#!/bin/bash

#set -x 

set -o pipefail

debug=1
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RESET='\033[m'

#echo "USB Connect"



# Print debug function
# --------------------
print_debug()
{
   if [[ $debug == 1 ]]; then
      echo -e $YELLOW"$1"$RESET
   fi
}

# Wrapper for the Amlogic 'update' command
# ----------------------------------------
run_update_return()
{
    local cmd
    local need_spaces

    cmd="./bin/update identify 7"
    need_spaces=0
    if [[ "$1" == "bulkcmd" ]] || [[ "$1" == "tplcmd" ]]; then
       need_spaces=1
    fi
    cmd+=" $1"
    shift 1

    for arg in "$@"; do
        if [[ "$arg" =~ ' ' ]]; then
           cmd+=" \"     $arg\""
        else
           if [[ $need_spaces == 1 ]]; then
              cmd+=" \"     $arg\""
           else
              cmd+=" $arg"
           fi
        fi
    done

    update_return=""
    print_debug "\nCommand ->$CYAN $cmd $RESET"
    if [[ "$simu" != "1" ]]; then
       update_return=`eval "$cmd"`
    fi
    print_debug "- Results ---------------------------------------------------"
    print_debug "$RED $update_return $RESET"
    print_debug "-------------------------------------------------------------"
    #print_debug ""
    return 0
}

# Wrapper to the Amlogic 'update' command
# ---------------------------------------
run_update()
{
    local cmd
    local ret=0

    run_update_return "$@"

    if `echo $update_return | grep -q "ERR"`; then
       ret=1
    fi
     print_debug "$GREEN 
[ Amlogic_GX-CHIP 1b8e:c003 device connected ]
"
    return $ret
}

# Assert update wrapper
# ---------------------
run_update_assert()
{
    run_update "$@"
    if [[ $? != 0 ]]; then
       print_debug "$RED 
[ Amlogic_GX-CHIP 1b8e:c003 device not connect!!!! ]
"
       exit 1
    fi
}

run_reboot_BL1()
{
    local cmd
    local need_spaces
	./bin/update identify 7
	./bin/update bulkcmd >/dev/null bootloader_is_old
	./bin/update bulkcmd >/dev/null erase_bootloader
	./bin/update bulkcmd >/dev/null reset
	 
    need_spaces=0
    if [[ "$1" == "bulkcmd" ]] || [[ "$1" == "tplcmd" ]]; then
       need_spaces=1
    fi
    cmd+=" $1"
    shift 1

    for arg in "$@"; do
        if [[ "$arg" =~ ' ' ]]; then
           cmd+=" \"     $arg\""
        else
           if [[ $need_spaces == 1 ]]; then
              cmd+=" \"     $arg\""
           else
              cmd+=" $arg"
           fi
        fi
    done

    update_return=""
    #print_debug "\nCommand ->$CYAN $cmd $RESET"
    if [[ "$simu" != "1" ]]; then
       update_return=`eval "$cmd"`
    fi

    return 0
}



run_update_assert

#run_update_return


echo "Reboot to BL1"

run_reboot_BL1


show_menu(){
    normal=`echo "\033[m"`
    menu=`echo "\033[36m"` #Blue
    number=`echo "\033[33m"` #yellow
    bgred=`echo "\033[41m"`
    fgred=`echo "\033[31m"`
    printf "\n${menu}*********************************************${normal}\n"
    printf "${menu}**${number} 1)${menu} S905 Dump BL1 ${normal}\n"
    printf "${menu}**${number} 2)${menu} S905 Dump Efuse ${normal}\n"
    printf "${menu}**${number} 3)${menu} S905X-H Dump BL1 ${normal}\n"
    printf "${menu}**${number} 4)${menu} S905X-H Dump Efuse${normal}\n"
    printf "${menu}**${number} 5)${menu} S905W Dump BL1${normal}\n"
    printf "${menu}**${number} 6)${menu} S905W Dump EFuse${normal}\n"
    printf "${menu}*********************************************${normal}\n"
    printf "Please enter a menu option and enter or ${fgred}x to exit. ${normal}"
    read opt
}

option_picked(){
    msgcolor=`echo "\033[01;31m"` # bold red
    normal=`echo "\033[00;00m"` # normal white
    message=${@:-"${normal}Error: No message passed"}
    printf "${msgcolor}${message}${normal}\n"
}

clear
show_menu
while [ $opt != '' ]
    do
    if [ $opt = '' ]; then
      exit;
    else
      case $opt in
        1) clear;
            option_picked "S905 Dump BL1";
            ./scripts/s905/dump_bootrom.sh;
            show_menu;
        ;;
        2) clear;
            option_picked "S905 Dump Efuse";
            ./scripts/s905/dump_efuse.sh;
            show_menu;
        ;;
        3) clear;
            option_picked "S905X-H Dump BL1";
            ./scripts/s905x-h/dump_bootrom.sh;
            show_menu;
        ;;
        4) clear;
            option_picked "S905X-H Dump Efuse";
            ./scripts/s905x-h/dump_efuse.sh;
            show_menu;
        ;;
        5) clear;
            option_picked "S905W Dump BL1";
            ./scripts/s905w/dump_bootrom.sh;
            show_menu;
        ;;
        6) clear;
            option_picked "S905W Dump Efuse";
            ./scripts/s905w/dump_efuse.sh;
            show_menu;
        ;;
        x)exit;
        ;;
        \n)exit;
        ;;
        *)clear;
            option_picked "Pick an option from the menu";
            show_menu;
        ;;
      esac
    fi
done
