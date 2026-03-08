# Weather SSID Updater for OpenWRT

This script updates the SSID of a dedicated virtual AP on OpenWRT to show current weather from wttr.in.

## Features
- Updates SSID with weather every 5 minutes (cron).
- Uses a dedicated virtual AP
- First-run setup stores selected radio, virtual AP section, and location in the script.
- WPA3 with random password enabled on virtual AP.

## Requirements
- OpenWRT 21.x or newer.
- `uci`, `iwinfo`, `wget` installed.
- Script must be run as root.

## Installation & Usage
1. Copy `weather_ssid.sh` to `/root/` and make it executable:
```sh
chmod +x /root/weather_ssid.sh
```
2. Run first time:
```sh
/root/weather_ssid.sh
```
3. Cron job will be automatically added for periodic updates.
4. Manual update:
```sh
/root/weather_ssid.sh
```

## Configuration
- Location and SSID base are stored in the script.
- Device (radio0/radio1) is selected on first run, virtual AP section is created.

## Notes
- No clients should connect to this virtual AP.
- Internet access is required for weather updates.
- The script uses absolute path for cron job, so renaming it is safe.

## Troubleshooting
- Run manually to see verbose output.
- Ensure root permissions and internet connectivity.

