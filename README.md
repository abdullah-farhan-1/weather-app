# Weather Data Pipeline (Bash)

Collects weather data for Pakistani cities from [wttr.in](https://wttr.in) on a schedule,
parses the JSON with `jq`, and appends readings to a CSV file per city.

## Scripts

- `setup_data.sh` – backs up the previous run, then creates fresh folders and CSV files with headers
- `extract_weather_data.sh` – downloads data for each city, extracts current and forecast temperatures, appends a row to each city's CSV, and logs successes and failures
- `restart.sh` – removes all generated data for a clean start

## Requirements

bash, curl, jq

## Usage

Edit the city list at the top of `setup_data.sh`, then run:

    ./setup_data.sh
    ./extract_weather_data.sh

To collect data automatically, schedule the extract script with cron, e.g. every 30 minutes:

    */30 * * * * /path/to/extract_weather_data.sh

## Output

Each city gets a folder in `output/` containing the latest raw JSON and a CSV with columns:

    time,day,month,year,current_temp,observed_at,forecasted_temperature,forecasted_time,forecasted_date
