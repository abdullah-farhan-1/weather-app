#!/usr/bin/env bash

cities_array=(Lahore Skardu "Arang Kel" Peshawar Karachi) #Customize this line only as per your need. Add "" with city names having whitespaces in them


basedir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
logs="$basedir/logs.txt"

date=$(date +"%I:%M:%S%p %d-%b-%Y") # 10:03:26PM 24-Oct-2026


# Create logs.txt if not exists

if ! [[ -f "$logs" ]]; then
    touch "$logs"
    echo "----- Logs.txt created -----"
    echo "----- Logs.txt created at $(date) -----" >> "$logs"
fi


# Data appending to logs.txt whenever this script runs

echo >> "$logs"
echo >> "$logs"
echo >> "$logs"
echo "---------- $date ----------" >> "$logs"
echo >> "$logs"
echo >> "$logs"


# Create backups directory if not exists and logs it

if ! [[ -d "$basedir/backups" ]]; then
    mkdir -p "$basedir/backups"
    echo "----- Backup folder didn't exist. Created now at "$basedir/backups/" -----"
    echo "$(date). Backup folder didn't exist. Created now" >> "$logs"
fi



# Backs up the previous run: if output/ exists and is not empty, moves its contents into backups/output.<date>/. If the move fails, the script stops (exit 1) so the city loop below can't overwrite the CSVs that are still in output/.


if [[ -d "$basedir/output" && -n "$(ls -A "$basedir/output")" ]]; then
    mkdir -p "$basedir/backups/output.${date}/"

    if mv "$basedir"/output/* "$basedir/backups/output.${date}/"; then
        echo "----- Backup $basedir/backups/output.${date}/ created -----"
        echo "Backup $basedir/backups/output.${date}/ created" >> "$logs"
    else
        echo "----- Backup FAILED. Stopping so no data is overwritten -----" >&2
        echo "$(date), Backup FAILED. Setup stopped" >> "$logs"
        exit 1
    fi
fi



# Creates a new output directory

if ! [[ -d "$basedir/output" ]]; then
    mkdir -p "${basedir}/output"
    echo "----- Output folder at "$basedir/output/" created -----"
    echo "Output folder at "$basedir/output/" created" >> "$logs"
fi



# Checks if cities_array is empty. Creates an empty .csv with header per city

if [[ "${#cities_array[@]}" > 0 ]]; then
    for city in "${cities_array[@]}"; do 
        mkdir -p "$basedir/output/${city}"
        dir="$basedir/output/${city}"
        echo "time,day,month,year,current_temp,observed_at,forecasted_temperature,forecasted_time,forecasted_date" > "$dir/${city}.csv"
    done
else
    echo "Cities array is empty. Add some cities"
fi

