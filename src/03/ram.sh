#!/bin/bash
if [[ $1 -eq 1 ]]
then
    ram=$(free | grep Mem | tr -s ' ' | cut -d$' ' -f2)
elif [[ $1 -eq 2 ]]
then
    ram=$(free | grep Mem | tr -s ' ' | cut -d$' ' -f3)
elif [[ $1 -eq 3 ]]
then
    ram=$(free | grep Mem | tr -s ' ' | cut -d$' ' -f4)
fi
    ram_gb_w=$((ram/1048576))
    ram_gb_f=$((ram*1000/1048576))
if [[ ram_gb_f -lt 100 ]]
then
    prefix="0"
elif [[ ram_gb_f -lt 10 ]]
then
    prefix="00"
fi

echo ""$ram_gb_w.$prefix$ram_gb_f" GB"