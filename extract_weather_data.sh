#!/usr/bin/env bash


# Paths setup

output_dir="/home/abdullah/Desktop/Data Engineering/7. Hands-on Introduction to Linux Commands and Shell Scripting/weather-app/output"
logs="/home/abdullah/Desktop/Data Engineering/7. Hands-on Introduction to Linux Commands and Shell Scripting/weather-app/logs.txt"



# Adds an empty line to logs.txt

echo >> "$logs"


# Core logic

for dir in "$output_dir"/*/; do
    city=$(basename "$dir")


    # Deals with cities having a space in their name. The api needs spaces to be replaced with +

    if [[ "$city" =~ [[:space:]] ]]; then 
        curl -s wttr.in/$(echo "$city" | tr ' ' '+')?format=j1 | jq -e '.' > "${output_dir}/${city}/data_${city}.json" 2>/dev/null # Sends errors to /dev/null in case the json is empty/errors

        sleep 1

        # Runs if the .json is empty
        if [[ ! -s "${output_dir}/${city}/data_${city}.json" ]]; then 
            echo "Could not find data for ${city}.json during this run"
            echo "$(date), Could not find data for ${city}.json during this run" >> "$logs"
            continue
        fi
        echo "Data found for ${city}!"
        echo "$(date), Data found for ${city}!" >> "$logs"
        
    else

        # For cities not having a space in their name
        curl -s wttr.in/"${city}"?format=j1 | jq -e '.' > "${output_dir}/${city}/data_${city}.json" 2>/dev/null # Sends errors to /dev/null in case the json is empty/errors

        sleep 1
        
        # Runs if the .json is empty
        if [[ ! -s "${output_dir}/${city}/data_${city}.json" ]]; then
            echo "Could not find data for ${city}.json during this run"
            echo "$(date), Could not find data for ${city}.json during this run" >> "$logs"
            continue
        fi
        echo "Data found for ${city}!"
        echo "$(date), Data found for ${city}!" >> "$logs"
    fi


    #Extract date and time fields
    now=$(date +"%I:%M:%S %p,%d,%b,%Y")   # 04:53 PM,24,Oct,2026


    #Extract weather data
    current_weather_time_utc=$(cat "${output_dir}/${city}/data_${city}.json" | jq -r '.current_condition[0].observation_time') # Extracts the time from the json, which is in UTC
    current_weather_time_local=$(TZ=Asia/Karachi date -d "$current_weather_time_utc UTC" +"%I:%M %p") # Converts UTC to PKT
    current_temperature=$(cat "${output_dir}/${city}/data_${city}.json" | jq -r '.current_condition[0].temp_C') # Extracts the current temperature
    forecasted_temperature_date=$(cat "${output_dir}/${city}/data_${city}.json" | jq -r '.weather[1].date') # Extracts forecasted date
    forecasted_temperature_time=$(cat "${output_dir}/${city}/data_${city}.json" | jq -r '.weather[1].hourly[4].time') # Extracts forecasted time
    forecasted_temperature_reading=$(cat "${output_dir}/${city}/data_${city}.json" | jq -r '.weather[1].hourly[4].tempC') # Extracts forecasted temperature


    # Appends extracted data to respective .csv files for the cities
    echo "$now","${current_temperature}C,${current_weather_time_local}","${forecasted_temperature_reading}"C,"${forecasted_temperature_time}","$forecasted_temperature_date" >> "${output_dir}/${city}/$city.csv"
done