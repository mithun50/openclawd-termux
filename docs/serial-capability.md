# Serial Capability

Communicate with physical hardware over **Bluetooth Classic** and **USB Serial** from the AI agent.

---

## Overview

The `serial` capability lets AI agents talk to microcontrollers and peripherals — Arduino, Micro:bit, HC-05, FTDI adapters, and any device that speaks serial. It uses a single unified command set with a `transport` parameter to switch between Bluetooth and USB.

**Transports:**

| Transport | Protocol | Supported Hardware |
|---|---|---|
| `bluetooth` | RFCOMM / SPP | HC-05, HC-06, Micro:bit, any Bluetooth Classic serial device |
| `usb` | USB Serial | Arduino (CDC-ACM), FTDI, CH340, CP210x, Micro:bit via USB OTG |

**Packages used:**

| Transport | Package |
|---|---|
| USB | [`flutter_serial_communication`](https://pub.dev/packages/flutter_serial_communication) (wraps `usb-serial-for-android`) |
| Bluetooth | [`flutter_bluetooth_classic_serial`](https://pub.dev/packages/flutter_bluetooth_classic_serial) |

---

## Commands

### `serial.scan` — Discover devices

Finds available devices for the given transport.

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `transport` | string | yes | — | `"bluetooth"` or `"usb"` |

**USB response:**
```json
{
  "transport": "usb",
  "devices": [
    {
      "name": "Arduino Uno",
      "deviceId": 3,
      "vendorId": 9025,
      "productId": 67,
      "manufacturer": "Arduino (www.arduino.cc)",
      "serialNumber": "55739323535351E0E0D1"
    }
  ]
}
```

**Bluetooth response:**
```json
{
  "transport": "bluetooth",
  "devices": [
    {
      "name": "HC-05",
      "address": "00:21:13:02:AA:BB",
      "paired": true
    }
  ]
}
```

> **Note:** Bluetooth scan returns **paired** devices only. Pair new devices via Android Settings > Bluetooth first.

---

### `serial.connect` — Open a connection

Opens a persistent serial connection to a device.

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `transport` | string | yes | — | `"bluetooth"` or `"usb"` |
| `address` | string | BT only | — | MAC address from scan (e.g. `"00:21:13:02:AA:BB"`) |
| `deviceId` | int | USB only | — | Device ID from scan |
| `baudRate` | int | no | `9600` | Baud rate (USB only). Common: 9600, 115200 |
| `name` | string | no | `"BT Device"` | Friendly name (BT only, for display) |

**Response:**
```json
{
  "connectionId": "usb_3",
  "transport": "usb",
  "device": "Arduino Uno",
  "vendorId": 9025,
  "productId": 67,
  "baudRate": 9600
}
```

**Connection IDs:**
- USB: `usb_<deviceId>` (e.g. `usb_3`)
- Bluetooth: `bt_<last6hex>` (e.g. `bt_02AABB`)

**Limits:** One connection per transport. USB and Bluetooth can be connected simultaneously. Attempting a second connection on the same transport returns `ALREADY_CONNECTED`.

---

### `serial.write` — Send data

Sends data to a connected device.

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `connectionId` | string | yes | — | Connection ID from `serial.connect` |
| `data` | string | yes | — | Data to send |
| `encoding` | string | no | `"utf8"` | `"utf8"` or `"base64"` |
| `appendNewline` | bool | no | `false` | Append `\n` after data |

**Response:**
```json
{
  "connectionId": "usb_3",
  "bytesWritten": 6
}
```

**Examples:**
```
# Send text with newline
serial.write connectionId:"usb_3" data:"Hello" appendNewline:true

# Send raw bytes via base64
serial.write connectionId:"usb_3" data:"uwAiAAAifg==" encoding:"base64"
```

---

### `serial.read` — Read buffered data

Reads from the incoming data buffer. Data is continuously buffered in the background (up to 64KB per connection).

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `connectionId` | string | yes | — | Connection ID |
| `maxBytes` | int | no | `1024` | Maximum bytes to return |
| `timeoutMs` | int | no | `2000` | Max wait time in milliseconds |
| `encoding` | string | no | `"utf8"` | `"utf8"` or `"base64"` for response |
| `delimiter` | string | no | — | Wait for this string (e.g. `"\n"`) |

**Response:**
```json
{
  "connectionId": "usb_3",
  "data": "Echo: Hello\n",
  "encoding": "utf8",
  "bytesRead": 12,
  "bufferRemaining": 0
}
```

**Behavior:**
- Without `delimiter`: returns immediately if buffer has data, otherwise waits up to `timeoutMs`
- With `delimiter`: waits until delimiter is found in buffer or `timeoutMs` expires
- If timeout expires with no data: returns `bytesRead: 0` and empty `data`
- `bufferRemaining` shows bytes left in buffer after this read

---

### `serial.disconnect` — Close a connection

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `connectionId` | string | yes | — | Connection ID, or `"all"` to close everything |

**Response:**
```json
{
  "connectionId": "usb_3",
  "disconnected": true
}
```

---

### `serial.list` — List active connections

No parameters required.

**Response:**
```json
{
  "connections": [
    {
      "connectionId": "usb_3",
      "transport": "usb",
      "device": "Arduino Uno",
      "bufferBytes": 42
    },
    {
      "connectionId": "bt_02AABB",
      "transport": "bluetooth",
      "device": "HC-05",
      "address": "00:21:13:02:AA:BB",
      "bufferBytes": 0
    }
  ]
}
```

---

## Permissions

| Transport | Android Permissions | Runtime Prompt? |
|---|---|---|
| USB | None (uses USB host API) | No |
| Bluetooth | `BLUETOOTH_CONNECT`, `BLUETOOTH_SCAN` | Yes (Android 12+) |

Legacy permissions (`BLUETOOTH`, `BLUETOOTH_ADMIN`) are declared with `maxSdkVersion="30"` for Android 11 and below.

USB uses `<uses-feature android:name="android.hardware.usb.host" android:required="false" />` — optional so the app installs on devices without USB OTG.

---

## Error Codes

| Code | When |
|---|---|
| `PERMISSION_DENIED` | User denied Bluetooth permission |
| `PERMISSION_PERMANENTLY_DENIED` | BT permission permanently denied (must enable in Settings) |
| `MISSING_PARAM` | Required parameter missing |
| `INVALID_PARAM` | Invalid transport value |
| `BT_NOT_SUPPORTED` | Device has no Bluetooth hardware |
| `BT_DISABLED` | Bluetooth adapter is off |
| `DEVICE_NOT_FOUND` | Device ID not in scan results |
| `CONNECT_FAILED` | Connection attempt failed |
| `ALREADY_CONNECTED` | Transport already has an active connection |
| `NOT_CONNECTED` | Connection ID doesn't match any active connection |
| `WRITE_FAILED` | Write operation returned false |
| `SCAN_ERROR` | Scan threw an exception |
| `SERIAL_ERROR` | Unhandled exception in capability |

---

## Examples

### Arduino LED Control

```
# 1. Scan for the Arduino
serial.scan transport:"usb"

# 2. Connect at 9600 baud
serial.connect transport:"usb" deviceId:3 baudRate:9600

# 3. Turn LED on
serial.write connectionId:"usb_3" data:"LED_ON" appendNewline:true

# 4. Read Arduino's response
serial.read connectionId:"usb_3" timeoutMs:3000 delimiter:"\n"

# 5. Done
serial.disconnect connectionId:"usb_3"
```

### Micro:bit Sensor Reading (Bluetooth)

```
# 1. Pair Micro:bit in Android Settings first, then scan
serial.scan transport:"bluetooth"

# 2. Connect using MAC address from scan
serial.connect transport:"bluetooth" address:"E4:F0:42:1A:2B:3C" name:"micro:bit"

# 3. Request sensor data
serial.write connectionId:"bt_1A2B3C" data:"READ_TEMP\n"

# 4. Read the temperature value
serial.read connectionId:"bt_1A2B3C" timeoutMs:5000 delimiter:"\n"
# → { "data": "TEMP:23.5\n", "bytesRead": 10 }

# 5. Disconnect
serial.disconnect connectionId:"bt_1A2B3C"
```

### Binary Protocol (base64)

```
# Send raw bytes: [0xBB, 0x00, 0x22, 0x00, 0x00, 0x22, 0x7E]
serial.write connectionId:"usb_3" data:"uwAiAAAifg==" encoding:"base64"

# Read raw response as base64
serial.read connectionId:"usb_3" encoding:"base64" timeoutMs:3000
```

### Multi-Device (USB + BT simultaneously)

```
serial.connect transport:"usb" deviceId:3 baudRate:115200
serial.connect transport:"bluetooth" address:"00:21:13:02:AA:BB"

serial.list
# → 2 connections active

serial.write connectionId:"usb_3" data:"MOTOR_FWD\n"
serial.write connectionId:"bt_02AABB" data:"SENSOR_READ\n"

serial.disconnect connectionId:"all"
```

---

## Architecture

```
┌─────────────────────────────────────────────┐
│           SerialCapability                   │
│  ┌──────────────────┐ ┌──────────────────┐  │
│  │   USB Transport  │ │   BT Transport   │  │
│  │                  │ │                  │  │
│  │ FlutterSerial-   │ │ FlutterBluetooth │  │
│  │ Communication    │ │ Classic          │  │
│  │                  │ │                  │  │
│  │ ┌──────────────┐ │ │ ┌──────────────┐ │  │
│  │ │ _ReadBuffer  │ │ │ │ _ReadBuffer  │ │  │
│  │ │  (64KB max)  │ │ │ │  (64KB max)  │ │  │
│  │ └──────────────┘ │ │ └──────────────┘ │  │
│  └──────────────────┘ └──────────────────┘  │
│                                             │
│  handleWithPermission() ← smart gate        │
│    BT commands → check BT permission        │
│    USB commands → skip permission check     │
└─────────────────────────────────────────────┘
```

---

## Troubleshooting

**USB device not found in scan:**
- Ensure USB OTG is supported by your Android device
- Try a different USB cable (some are charge-only)
- Android may show a permission dialog for USB device access — approve it

**Bluetooth device not listed:**
- Pair the device first in Android Settings > Bluetooth
- `serial.scan transport:"bluetooth"` only returns paired devices
- Ensure the device is powered on and in range

**Connect fails:**
- USB: Verify the baud rate matches your device firmware (default: 9600)
- BT: Ensure the device isn't already connected to another app
- Try `serial.disconnect connectionId:"all"` and reconnect

**Read returns empty:**
- Increase `timeoutMs` — the device may be slow to respond
- Check that you sent data the device expects (including newline if needed)
- Use `serial.list` to verify the connection is still active and check `bufferBytes`
