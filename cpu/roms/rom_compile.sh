#!/bin/bash

delete=0
help_text=0
while [[ $# -gt 1 ]]
do
    key="$1"

    case $key in
        -D|--delete)
        delete=1
        shift
        ;;
        -h|--help)
        help_text=1
        shift
        ;;
        *)
        ;;
    esac
done

if [[ $help_text -eq 1 ]]; then
    echo "Usage: ./rom_compile.sh [-D] foo.c"
    echo "Default: Compiles a c file to a GBA ROM, including text bytes"
    echo "-D: Deletes files created from compiling"
    exit
fi

cfile=$1
file_base=${cfile%.c}
obj_file=${file_base}.o
elf_file=${file_base}.elf
gba_file=${file_base}.gba
hex_file=${file_base}.hex

if [[ $delete -eq 1 ]]; then
    rm -f $obj_file
    rm -f $elf_file
    rm -f $gba_file
    rm -f $hex_file
else
    arm-none-eabi-gcc -c $cfile -mthumb-interwork -mthumb -O2 -g -o $obj_file
    arm-none-eabi-gcc $obj_file -mthumb-interwork -mthumb -g -specs=gba.specs -o $elf_file
    arm-none-eabi-objcopy -v -O binary $elf_file $gba_file
    gbafix $gba_file
    xxd -ps -c 1 $gba_file > $hex_file
fi
