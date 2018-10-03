#!/bin/sh
# shell script to prepend i3status with more stuff

skip=3
count=0
i3status | while :
do
        read line
        if [ $count -lt $skip ]; then
            echo $line
        else
            light_out=$(light -G)
            light="{\"name\":\"brightness\",\"full_text\":\"☀️ ${light_out%.*}\"}"
            line=",[$light,${line:2}"

            num=$(cat .updates)
            if [[ $num -ne "0" ]]; 
            then 
                status="{\"name\":\"pacman\",\"full_text\":\"📦 ⚠️ $num\"}"
                echo ",[$status,${line:2}"
            else
                echo $line
            fi
        fi
        count=`expr $count + 1`
done
