#!/usr/bin/env bash

#Deletes the logs.txt file as well as output and backups directories


basedir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
output="$basedir/output"
logs="$basedir/logs.txt"
backups="$basedir/backups"


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
