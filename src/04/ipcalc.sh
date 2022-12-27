#!/bin/sh

function mask255 {
    if [ $1 -eq 8 ]
    then
        val=255
    elif [ $1 -eq 7 ]
    then
        val=254
        elif [ $1 -eq 6 ]
        then
            val=252
            elif [ $1 -eq 5 ]
            then
                val=248
                elif [ $1 -eq 4 ]
                then
                    val=240
                    elif [ $1 -eq 3 ]
                    then
                        val=224
                        elif [ $1 -eq 2 ]
                        then
                            val=192
                            elif [ $1 -eq 1 ]
                            then
                                val=128
                            else
                                val=0
                            fi
    echo $val
}


iprealma=""
mask=$1
mask1=$mask
for ((i = 0; i < 4; i++))
do
    if [ $mask1 -lt 8 ]
    then
        if [ $mask1 -le 0 ]
        then
            value=$( mask255 0 )
        else
            value=$( mask255 $mask1 )
        fi
        # echo OPOP= $value
    else
        value=$( mask255 8 )
    fi
    realmask="$realma$value."
    realma="$realmask"
    mask1=$(( $mask - 8 ))
    mask=$mask1
done
echo $realmask