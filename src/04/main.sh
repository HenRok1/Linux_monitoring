#!/bin/bash

configurate_file="color.conf"

color_background=()
color_background[1]="\e[107m"; #WHITE
color_background[2]="\e[101m"; #RED
color_background[3]="\e[102m"; #GREEN
color_background[4]="\e[104m"; #BLUE
color_background[5]="\e[105m"; #PURPLE
color_background[6]="\e[40m";#BLACK
color_background["default"]="\e[107m"


color_font=()
color_font[1]="\e[97m"; #WHITE
color_font[2]="\e[91m"; #RED
color_font[3]="\e[92m"; #GREEN
color_font[4]="\e[94m"; #BLUE
color_font[5]="\e[35m"; #PURPLE
color_font[6]="\e[30m"; #BLACK
color_font["default"]="\e[30m"

declare -A color_name
color_name["\e[97m"]="white";
color_name["\e[91m"]="red"
color_name["\e[92m"]="green"
color_name["\e[94m"]="blue"
color_name["\e[35m"]="purple"
color_name["\e[30m"]="black"
color_name["\e[107m"]="white"
color_name["\e[101m"]="red"
color_name["\e[102m"]="green"
color_name["\e[104m"]="blue"
color_name["\e[105m"]="purple"
color_name["\e[40m"]="black"

null=" \e[0m"

function parametrs {
    declare -a parm_name
    parm_name+=("HOSTNAME")
    parm_name+=("TIMEZONE")
    parm_name+=("USER")
    parm_name+=("OS")
    parm_name+=("DATE")
    parm_name+=("UPTIME")
    parm_name+=("UPTIME_SEC")
    parm_name+=("IP")
    parm_name+=("MASK")
    parm_name+=("GATEWAY")
    parm_name+=("RAM_TOTAL")
    parm_name+=("RAM_USED")
    parm_name+=("RAM_FREE")
    parm_name+=("SPACE_ROOT")
    parm_name+=("SPACE_ROOT_USED")
    parm_name+=("SPACE_ROOT_FREE")
    
    declare -A parm
    parm["HOSTNAME"]=$(hostname)
    timezone=`timedatectl | awk '/Time zone:/{print $3}'`
    date=" $(date +"%Z %z")"
    parm["TIMEZONE"]=$timezone$date 
    parm["USER"]=$(whoami)
    parm["OS"]=$(hostnamectl | grep "Operating System" | cut -c 21-)
    parm["DATE"]=$(date +"%d %b %Y %H:%M:%S")
    uptime=$(uptime | awk '{print $3}' | tr -d ,)
    parm["UPTIME"]=$uptime
    parm["UPTIME_SEC"]=$(sudo cat /proc/uptime | awk '{print int($1) " seconds"}')
    ip=$(ip route get 1 | awk '{print $(NF-2);exit}')
    parm["IP"]=$ip
    mask=$(ip route | grep -e ${ip} | grep /| awk '{print $1}' | awk -F / '{print $2}')
    parm["MASK"]=$(bash ipcalc.sh $mask )
    parm["GATEWAY"]=$(ip route show 0.0.0.0/0 | awk '{print $3}')
    parm["RAM_TOTAL"]=$(bash ./ram.sh 1)
    parm["RAM_USED"]=$(bash ./ram.sh 2)
    parm["RAM_FREE"]=$(bash ./ram.sh 3)
    root=$(df -Bk | grep -e '/$')
    parm["SPACE_ROOT"]=$(echo $root | awk '{printf "%.2f MB", $2/1000}')
    parm["SPACE_ROOT_USED"]=$(echo $root | awk '{printf "%.2f MB", $3/1000}')
    parm["SPACE_ROOT_FREE"]=$(echo $root | awk '{printf "%.2f MB", $4/1000}')

    for i in "${parm_name[@]}"
    do
        echo -e "${1}${2}$i$null = ${3}${4}${parm[$i]}$null"
    done
}

declare -a color_set
i=0
p=
for var in $(cat $configurate_file)
do
    (( i++))
    color_set[$i]=$(echo $var | awk -F "=" '{print $2}')
    if [[ ${color_set[$i]} -lt 1 || ${color_set[$i]} -gt 6 ]]
    then
        color_set[$i]="default"
    fi
done
val1=${color_set[1]}
val2=${color_set[2]}
val3=${color_set[3]}
val4=${color_set[4]}
if [[ ( $val1 -eq $val2 || $val3 -eq $val4 ) && $val1 -ne "default" && $val3 -ne "default" ]]
then
    echo "Background color and font color should not be repeated"
    echo "Repeat attemp"
    exit 2
else
    parametrs ${color_background[$val1]} ${color_font[$val2]} ${color_background[$val3]} ${color_font[$val4]}
fi

echo
echo "Column 1 background = $val1 (${color_name[${color_background[$val1]}]})"
echo "Column 1 font color = $val2 (${color_name[${color_font[$val2]}]})"
echo "Column 2 background = $val3 (${color_name[${color_background[$val3]}]})"
echo "Column 2 font color = $val4 (${color_name[${color_font[$val4]}]})"