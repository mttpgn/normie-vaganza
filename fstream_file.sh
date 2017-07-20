#!/bin/bash

APIKEY=`cat /etc/twitchapikey`
ffmpeg -re -i $1 -vcodec libx264 -preset fast -crf 30 -acodec aac -framerate 24 -ab 128k -ar 44100 -strict experimental -f flv rtmp://live-dfw.twitch.tv/app/$APIKEY

exit 0

