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
