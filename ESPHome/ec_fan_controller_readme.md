# EC Fan Controller - ESPHome

This ESPHome project controls an EC fan using temperature feedback from a SHT41 sensor.

## Features
- Automatic fan speed control based on configurable min/max temperature.
- Manual fan speed control retained via Home Assistant or button input.
- SHT41 temperature and humidity sensor.
- Status LED indicating temperature level.
- Minimum run and off times to protect fan from rapid switching.

## Wiring
- **SHT41**: I2C connection (SDA/SCL pins)
- **EC fan**: PWM control connected to fan input
- **Status LED** (optional): WS2812 connected to LED pin
- **Button input**: GPIO pin configured as input with pull-up

## Notes
- Automatic mode can be toggled on/off via switch.
- LED brightness and fan limits can be configured in Home Assistant.
- PWM mapping ensures full manual control while allowing automatic adjustment.

## Setup Instructions
1. Flash the YAML file to your ESP32 C6 using ESPHome.
2. Connect to your Wi-Fi network or fallback hotspot.
3. Verify sensors and outputs are working in ESPHome dashboard.
4. Adjust min/max temperature and run/off times as desired.
5. Use Home Assistant or button to control the fan manually or let automatic mode manage it.

