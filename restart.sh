#!/usr/bin/env bash

#Deletes the logs.txt file as well as output and backups directories


output="/home/abdullah/Desktop/Data Engineering/7. Hands-on Introduction to Linux Commands and Shell Scripting/weather-app/output"
logs="/home/abdullah/Desktop/Data Engineering/7. Hands-on Introduction to Linux Commands and Shell Scripting/weather-app/logs.txt"
backups="/home/abdullah/Desktop/Data Engineering/7. Hands-on Introduction to Linux Commands and Shell Scripting/weather-app/backups"


if [[ -d "$output" ]]; then
    rm -r "$output"
    echo ""$output" deleted"
fi

if [[ -d "$backups" ]]; then
    rm -r "$backups"
    echo ""$backups" deleted"
fi

if [[ -f "$logs" ]]; then
    rm "$logs"
    echo ""$logs" deleted"
fi