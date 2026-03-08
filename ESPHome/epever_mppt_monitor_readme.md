# MPPT Monitor for Epever Tracer 3210AN

This ESPHome project allows you to monitor an **Epever Tracer 3210AN MPPT controller** using an ESP8266 device. It communicates via **RS485 Modbus** and provides a variety of measurements such as PV voltage, battery SOC, currents, power, and temperatures.

## Features

- Reads PV input voltage, current, and power  
- Reads battery voltage, current, SOC, and temperature  
- Reads load voltage, current, and power  
- Controller temperature  
- Total generated and consumed energy  
- Charging status with proper handling of unknown states  
- Modbus-controlled switches: start/stop charging, clear energy stats  
- Web server interface with authentication  
- OTA updates

## Hardware Setup

### RS485 Connection

- Use an **RS485 to TTL converter** to connect the MPPT controller to the ESP8266 UART pins.  
- Example wiring:

```
MPPT RS485 A <-> RS485 Module A
MPPT RS485 B <-> RS485 Module B
RS485 Module TX <-> ESP8266 RX
RS485 Module RX <-> ESP8266 TX
RS485 Module GND <-> ESP8266 GND
```

- Ensure proper termination if your cable is long (>30 m) or there are multiple devices.

### Power Supply

- If powering the ESP8266 from the MPPT controller port, **add a small capacitor (e.g., 100 µF) across the power and GND lines**.  
- This helps prevent ESP8266 startup issues due to current spikes.

## Installation

1. Install [ESPHome](https://esphome.io/) on your development machine.  
2. Copy the YAML configuration (`mppt-monitor.yaml`) and edit your Wi-Fi and credentials.  
3. Flash the ESP8266 device with ESPHome.  
4. After boot, the ESP will connect to Wi-Fi and start reading data from the MPPT controller.  
5. Optionally, integrate with Home Assistant via the ESPHome API.

## Notes

- The first boot sets the RTC on the MPPT controller using the current SNTP time. Make sure the ESP8266 has a working network connection.  
- All values from the MPPT are converted to human-readable units with appropriate scaling.  
- Charging status is handled via a template sensor. Any unknown or future states beyond defined values will return `"Unknown"`.
- You can restart the device or clear energy statistics from the web server or Home Assistant.  

