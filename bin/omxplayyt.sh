#!/bin/bash
clear > /dev/tty1
echo "Playing: $1"
echo
omxplayer -o local $(youtube-dl -g "$1")
