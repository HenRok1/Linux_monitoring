#!/bin/sh

function parametrs {
# HOSTNAME
echo "HOSTNAME = $(hostname)"
# TIMEZONE
timezone=`timedatectl | awk '/Time zone:/{print $3}'`
date=$(date +"%Z %z")
echo "TIMEZONE = $timezone $date"
# USER
echo USER = $(whoami)
# OS
echo OS = $(hostnamectl | grep "Operating System" | cut -c 21-)
# DATE
echo DATE = $(date +"%d %b %Y %H:%M:%S")
# UPTIME
uptime=$(uptime | awk '{print $3}' | tr -d ,)
echo UPTIME = $uptime
# UPTIME_SEC
echo UPTIME_SEC = $(sudo cat /proc/uptime | awk '{print int($1) " seconds"}')
# IP
ip=$(ip route get 1 | awk '{print $(NF-2);exit}')
echo IP = $ip

# MASK
mask=$(ip route | grep -e ${ip} | grep /| awk '{print $1}' | awk -F / '{print $2}')
echo MASK = $(bash ipcalc.sh $mask )
# echo MASK = $mask
# GATEWAY
echo GATEMAY = $(ip route show 0.0.0.0/0 | awk '{print $3}')
#RAM
echo RAM_TOTAL = $(bash ./ram.sh 1)
echo RAM_USED = $(bash ./ram.sh 2)
echo RAM_FREE = $(bash ./ram.sh 3)
# ROOT
root=$(df -Bk | grep -e '/$')
echo SPACE_ROOT = $(echo $root | awk '{printf "%.2f MB", $2/1000}')
echo SPACE_ROOT_USED = $(echo $root | awk '{printf "%.2f MB", $3/1000}')
echo SPACE_ROOT_FREE = $(echo $root | awk '{printf "%.2f MB", $4/1000}')
}

parametrs

echo "Write to file? [Y/N]"
answer='n'
read answer
if [[ $answer = 'Y' || $answer = 'y' ]]
then
    datef=$(date +"%d_%m_%Y_%H_%M_%S")
    # touch ${datef}.status
    # chmod +x ${datef}.status
    parametrs > "${datef}.status"
fi