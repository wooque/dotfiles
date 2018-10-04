#!/bin/sh

pid=$(ps aux | grep "i3status.py" | grep -v grep | awk '{print $2}')
if [[ -n $pid ]]
then 
    kill -HUP $pid
fi
