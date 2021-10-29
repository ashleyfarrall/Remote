#/bin/bash

declare -i logouttime=3600000
user=$(ps aux | grep gnome-session |  awk '{print $1}' | egrep '(^[0-9])' | head -n 1)
display=$(w | grep $user | awk '{print $2}')
uid=$(id -u $user)
idletime=$(sudo -u $user DISPLAY=$display xprintidle)

if [ "$idletime" -gt "$logouttime" ]; then
   displaypid=$(ps auxf | grep gnome-session |  awk '{print $1, $2}' | egrep '(^[0-9])' | awk '{print $2}' | head -n 1)
   sudo -u $user DISPLAY=$display DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus notify-send "You've been idle too long, bye!"
   sleep 60; kill $displaypid
fi
