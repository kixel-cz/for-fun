#!/bin/sh

# Weather SSID updater for OpenWRT
# Updates a dedicated AP's SSID with current weather
# First run: selects radio and creates AP section with random password
# Subsequent runs: updates SSID only

# ------------------------
# CONFIGURATION SECTION
# ------------------------
DEVICE=""       # e.g., radio0 (selected on first run)
SECTION=""      # e.g., wifinet6 (created on first run)
LOCATION=""     # e.g. Prague

SSSD_BASE="Weather Station"  # initial SSID
SECURITY="sae"  # WPA3 Personal

# ------------------------
# VERBOSE FUNCTION
# ------------------------
info() { echo "[INFO] $*"; }

# ------------------------
# FIRST RUN: select radio and create AP
# ------------------------
if [ -z "$DEVICE" ] || [ -z "$SECTION" ] || [ -z "$LOCATION" ]; then
    info "First run detected: some settings not set."

    # list available radios
    RADIOS=$(uci show wireless | grep '\.device=' | cut -d\' -f2 | sort -u)
    i=0
    for r in $RADIOS; do
        echo "  $i) $r"
        i=$((i+1))
    done

    # Select radio
    read -p "Enter the number of the radio to use: " choice
    DEVICE=$(echo "$RADIOS" | sed -n "$((choice+1))p")

    # Determine next wifinet index
    MAX_INDEX=-1
    for sec in $(uci show wireless | grep "=wifi-iface" | cut -d'.' -f2); do
        idx=$(echo "$sec" | sed -n 's/^wifinet\([0-9]\+\)$/\1/p')
        if [ -n "$idx" ]; then
            [ "$idx" -gt "$MAX_INDEX" ] && MAX_INDEX=$idx
        fi
    done
    NEW_INDEX=$((MAX_INDEX+1))
    SECTION="wifinet$NEW_INDEX"

    # Generate random password
    PASS=$(tr -dc 'A-Za-z0-9!@#$%&*' </dev/urandom | head -c16)

    # Create section
    info "Creating new AP section: $SECTION on $DEVICE"
    uci add wireless wifi-iface
    uci rename wireless.@wifi-iface[-1]="$SECTION"
    uci set wireless.$SECTION.device="$DEVICE"
    uci set wireless.$SECTION.mode='ap'
    uci set wireless.$SECTION.ssid="$SSID_BASE"
    uci set wireless.$SECTION.encryption="$SECURITY"
    uci set wireless.$SECTION.key="$PASS"
    uci commit wireless
    wifi reload
    info "Section '$SECTION' created with SSID '$SSID_BASE' and random password."

    # Define location
    read -p "Enter location name for wttr.in: " LOCATION

    # Write settings into script for next run
    sed -i "s|^DEVICE=.*|DEVICE=\"$DEVICE\"|" "$0"
    sed -i "s|^SECTION=.*|SECTION=\"$SECTION\"|" "$0"
    sed -i "s|^LOCATION=.*|LOCATION=\"$LOCATION\"|" "$0"

    # Cron setup
    SCRIPT_PATH=$(readlink -f "$0")
    if ! crontab -l 2>/dev/null | grep -q "$SCRIPT_PATH"; then
        (crontab -l 2>/dev/null; echo "*/5 * * * * $SCRIPT_PATH") | crontab -
        info "Cron job added to update SSID every 5 minutes."
    else
        info "Cron job already exists."
    fi

    info "Settings written into script."
fi

# ------------------------
# UPDATE SSID
# ------------------------
info "Using DEVICE: $DEVICE and SECTION: $SECTION"
# Fetch weather info
WEATHER=$(wget -qO- "http://wttr.in/$LOCATION?format=%c+%t+%w+%m" | tr -d '\n')
if [ -z "$WEATHER" ]; then
    info "Weather info not available. Skipping update."
    exit 1
fi

uci set wireless.$SECTION.ssid="$SSID_BASE: $WEATHER"
uci commit wireless
wifi reload
info "SSID updated to: $SSID_BASE: $WEATHER"
