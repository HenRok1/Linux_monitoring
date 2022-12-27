#!/bin/sh

re='^[0-9]+$'
if [ -n "$1" ]
then
    if ! [[ $1 =~ $re ]]
    then
        echo "$1"
    else
        echo "No text in parametr."
    fi
else
    echo "No parametrs found. "
fi