import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_serial_communication/flutter_serial_communication.dart';
import 'package:flutter_bluetooth_classic_serial/flutter_bluetooth_classic.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/node_frame.dart';
import 'capability_handler.dart';

/// Circular read buffer for incoming serial data (capped at 64 KB).
class _ReadBuffer {
  final List<int> _bytes = [];
  static const int maxSize = 65536;

  int get length => _bytes.length;

  void add(List<int> data) {
    _bytes.addAll(data);
    if (_bytes.length > maxSize) {
      _bytes.removeRange(0, _bytes.length - maxSize);
    }
  }

  List<int> take(int maxBytes) {
    final count = maxBytes.clamp(0, _bytes.length);
    final chunk = _bytes.sublist(0, count);
    _bytes.removeRange(0, count);
    return chunk;
  }

  int findDelimiter(List<int> delimiter) {
    if (delimiter.isEmpty || _bytes.length < delimiter.length) return -1;
    outer:
    for (int i = 0; i <= _bytes.length - delimiter.length; i++) {
      for (int j = 0; j < delimiter.length; j++) {
        if (_bytes[i + j] != delimiter[j]) continue outer;
      }
      return i;
    }
    return -1;
  }

  List<int> takeUntilDelimiter(List<int> delimiter) {
    final idx = findDelimiter(delimiter);
    if (idx < 0) return [];
    final end = idx + delimiter.length;
    final chunk = _bytes.sublist(0, end);
    _bytes.removeRange(0, end);
    return chunk;
  }
}

/// Serial capability supporting both Bluetooth Classic and USB serial.
///
/// One active connection per transport (plugin limitation).
/// Connection IDs: `usb_<deviceId>` for USB, `bt_<last6hex>` for Bluetooth.
class SerialCapability extends CapabilityHandler {
  // ── USB state ──────────────────────────────────────────────────────────
  final FlutterSerialCommunication _usbSerial = FlutterSerialCommunication();
  String? _usbConnectionId;
  String? _usbDeviceName;
  _ReadBuffer? _usbBuffer;
  StreamSubscription? _usbDataSub;
  List<DeviceInfo>? _lastUsbDevices;

  // ── Bluetooth state ────────────────────────────────────────────────────
  final FlutterBluetoothClassic _btSerial = FlutterBluetoothClassic();
  String? _btConnectionId;
  String? _btDeviceName;
  String? _btAddress;
  _ReadBuffer? _btBuffer;
  StreamSubscription? _btDataSub;

  @override
  String get name => 'serial';

  @override
  List<String> get commands =>
      ['scan', 'connect', 'write', 'read', 'disconnect', 'list'];

  @override
  List<Permission> get requiredPermissions => [
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ];

  @override
  Future<bool> checkPermission() async {
    return await Permission.bluetoothConnect.isGranted &&
        await Permission.bluetoothScan.isGranted;
  }

  @override
  Future<bool> requestPermission() async {
    final statuses = await [
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request();
    return statuses.values.every((s) => s.isGranted);
  }

  /// Only require Bluetooth permissions when the command targets BT transport.
  @override
  Future<NodeFrame> handleWithPermission(
      String command, Map<String, dynamic> params) async {
    final transport = params['transport'] as String?;
    final connectionId = params['connectionId'] as String?;

    bool needsBt = false;
    if (transport == 'bluetooth') needsBt = true;
    if (connectionId != null && connectionId.startsWith('bt_')) needsBt = true;

    if (needsBt) {
      return super.handleWithPermission(command, params);
    }
    return handle(command, params);
  }

  @override
  Future<NodeFrame> handle(
      String command, Map<String, dynamic> params) async {
    try {
      switch (command) {
        case 'serial.scan':
          return await _scan(params);
        case 'serial.connect':
          return await _connect(params);
        case 'serial.write':
          return await _write(params);
        case 'serial.read':
          return await _read(params);
        case 'serial.disconnect':
          return await _disconnect(params);
        case 'serial.list':
          return _list();
        default:
          return _error('UNKNOWN_COMMAND', 'Unknown serial command: $command');
      }
    } catch (e) {
      return _error('SERIAL_ERROR', '$e');
    }
  }

  // ── scan ────────────────────────────────────────────────────────────────

  Future<NodeFrame> _scan(Map<String, dynamic> params) async {
    final transport = params['transport'] as String?;
    if (transport == null) {
      return _error(
          'MISSING_PARAM', 'transport required ("bluetooth" or "usb")');
    }
    if (transport == 'usb') return _scanUsb();
    if (transport == 'bluetooth') return _scanBluetooth();
    return _error('INVALID_PARAM', 'transport must be "bluetooth" or "usb"');
  }

  Future<NodeFrame> _scanUsb() async {
    try {
      final devices = await _usbSerial.getAvailableDevices();
      _lastUsbDevices = devices;
      return NodeFrame.response('', payload: {
        'transport': 'usb',
        'devices': devices
            .map((d) => {
                  'name': d.deviceName ?? d.productName ?? 'Unknown USB Device',
                  'deviceId': d.deviceId,
                  'vendorId': d.vendorId,
                  'productId': d.productId,
                  'manufacturer': d.manufacturerName,
                  'serialNumber': d.serialNumber,
                })
            .toList(),
      });
    } catch (e) {
      return _error('SCAN_ERROR', 'USB scan failed: $e');
    }
  }

  Future<NodeFrame> _scanBluetooth() async {
    try {
      final supported = await _btSerial.isBluetoothSupported();
      if (!supported) {
        return _error(
            'BT_NOT_SUPPORTED', 'Bluetooth not supported on this device');
      }
      final enabled = await _btSerial.isBluetoothEnabled();
      if (!enabled) {
        return _error(
            'BT_DISABLED', 'Bluetooth is disabled. Enable it in settings.');
      }
      final devices = await _btSerial.getPairedDevices();
      return NodeFrame.response('', payload: {
        'transport': 'bluetooth',
        'devices': devices
            .map((d) => {
                  'name': d.name,
                  'address': d.address,
                  'paired': true,
                })
            .toList(),
      });
    } catch (e) {
      return _error('SCAN_ERROR', 'Bluetooth scan failed: $e');
    }
  }

  // ── connect ─────────────────────────────────────────────────────────────

  Future<NodeFrame> _connect(Map<String, dynamic> params) async {
    final transport = params['transport'] as String?;
    if (transport == null) {
      return _error('MISSING_PARAM', 'transport required');
    }
    if (transport == 'usb') return _connectUsb(params);
    if (transport == 'bluetooth') return _connectBluetooth(params);
    return _error('INVALID_PARAM', 'transport must be "bluetooth" or "usb"');
  }

  Future<NodeFrame> _connectUsb(Map<String, dynamic> params) async {
    if (_usbConnectionId != null) {
      return _error('ALREADY_CONNECTED',
          'USB already connected ($_usbConnectionId). Disconnect first.');
    }

    final deviceId = params['deviceId'];
    final baudRate = params['baudRate'] as int? ?? 9600;
    if (deviceId == null) {
      return _error('MISSING_PARAM', 'deviceId required for USB');
    }

    _lastUsbDevices ??= await _usbSerial.getAvailableDevices();
    DeviceInfo? device;
    for (final d in _lastUsbDevices!) {
      if (d.deviceId.toString() == deviceId.toString()) {
        device = d;
        break;
      }
    }
    if (device == null) {
      return _error(
          'DEVICE_NOT_FOUND', 'Device $deviceId not found. Run serial.scan.');
    }

    final ok = await _usbSerial.connect(device, baudRate);
    if (!ok) {
      return _error('CONNECT_FAILED', 'USB connect failed');
    }

    final connId = 'usb_${device.deviceId}';
    _usbConnectionId = connId;
    _usbDeviceName = device.deviceName ?? device.productName ?? 'USB Device';
    _usbBuffer = _ReadBuffer();

    _usbDataSub?.cancel();
    _usbDataSub = _usbSerial
        .getSerialMessageListener()
        .receiveBroadcastStream()
        .listen((event) {
      if (event is Uint8List) {
        _usbBuffer?.add(event);
      } else if (event is List) {
        _usbBuffer?.add(List<int>.from(event));
      } else if (event is String) {
        _usbBuffer?.add(utf8.encode(event));
      }
    });

    return NodeFrame.response('', payload: {
      'connectionId': connId,
      'transport': 'usb',
      'device': _usbDeviceName,
      'vendorId': device.vendorId,
      'productId': device.productId,
      'baudRate': baudRate,
    });
  }

  Future<NodeFrame> _connectBluetooth(Map<String, dynamic> params) async {
    if (_btConnectionId != null) {
      return _error('ALREADY_CONNECTED',
          'Bluetooth already connected ($_btConnectionId). Disconnect first.');
    }

    final address = params['address'] as String?;
    if (address == null || address.isEmpty) {
      return _error('MISSING_PARAM', 'address required for Bluetooth');
    }

    final ok = await _btSerial.connect(address);
    if (!ok) {
      return _error('CONNECT_FAILED', 'Bluetooth connect failed at $address');
    }

    final clean = address.replaceAll(':', '');
    final suffix =
        clean.length >= 6 ? clean.substring(clean.length - 6) : clean;
    final connId = 'bt_$suffix';
    _btConnectionId = connId;
    _btAddress = address;
    _btDeviceName = params['name'] as String? ?? 'BT Device';
    _btBuffer = _ReadBuffer();

    _btDataSub?.cancel();
    _btDataSub = _btSerial.onDataReceived.listen((event) {
      if (event is List<int>) {
        _btBuffer?.add(event);
      } else {
        try {
          final data = (event as dynamic).data;
          if (data is List<int>) {
            _btBuffer?.add(data);
          }
        } catch (_) {}
      }
    });

    return NodeFrame.response('', payload: {
      'connectionId': connId,
      'transport': 'bluetooth',
      'device': _btDeviceName,
      'address': address,
    });
  }

  // ── write ───────────────────────────────────────────────────────────────

  Future<NodeFrame> _write(Map<String, dynamic> params) async {
    final connectionId = params['connectionId'] as String?;
    if (connectionId == null) {
      return _error('MISSING_PARAM', 'connectionId required');
    }
    final data = params['data'] as String?;
    if (data == null) {
      return _error('MISSING_PARAM', 'data required');
    }

    final encoding = params['encoding'] as String? ?? 'utf8';
    final appendNewline = params['appendNewline'] as bool? ?? false;

    List<int> bytes;
    if (encoding == 'base64') {
      bytes = base64Decode(data);
    } else {
      bytes = utf8.encode(data);
    }
    if (appendNewline) {
      bytes = [...bytes, 0x0A];
    }

    if (connectionId == _usbConnectionId && _usbConnectionId != null) {
      final ok = await _usbSerial.write(Uint8List.fromList(bytes));
      if (!ok) return _error('WRITE_FAILED', 'USB write failed');
      return NodeFrame.response('', payload: {
        'connectionId': connectionId,
        'bytesWritten': bytes.length,
      });
    }

    if (connectionId == _btConnectionId && _btConnectionId != null) {
      final ok = await _btSerial.sendData(bytes);
      if (!ok) return _error('WRITE_FAILED', 'Bluetooth write failed');
      return NodeFrame.response('', payload: {
        'connectionId': connectionId,
        'bytesWritten': bytes.length,
      });
    }

    return _error('NOT_CONNECTED', 'No connection: $connectionId');
  }

  // ── read ────────────────────────────────────────────────────────────────

  Future<NodeFrame> _read(Map<String, dynamic> params) async {
    final connectionId = params['connectionId'] as String?;
    if (connectionId == null) {
      return _error('MISSING_PARAM', 'connectionId required');
    }

    final maxBytes = params['maxBytes'] as int? ?? 1024;
    final timeoutMs = params['timeoutMs'] as int? ?? 2000;
    final encoding = params['encoding'] as String? ?? 'utf8';
    final delimiter = params['delimiter'] as String?;

    _ReadBuffer? buffer;
    if (connectionId == _usbConnectionId) {
      buffer = _usbBuffer;
    } else if (connectionId == _btConnectionId) {
      buffer = _btBuffer;
    }
    if (buffer == null) {
      return _error('NOT_CONNECTED', 'No connection: $connectionId');
    }

    final delimBytes = delimiter != null ? utf8.encode(delimiter) : null;
    final deadline = DateTime.now().add(Duration(milliseconds: timeoutMs));

    while (DateTime.now().isBefore(deadline)) {
      if (delimBytes != null) {
        if (buffer.findDelimiter(delimBytes) >= 0) {
          final chunk = buffer.takeUntilDelimiter(delimBytes);
          return _readResponse(connectionId, chunk, encoding, buffer.length);
        }
      } else if (buffer.length > 0) {
        break;
      }
      await Future.delayed(const Duration(milliseconds: 50));
    }

    final chunk = buffer.take(maxBytes);
    return _readResponse(connectionId, chunk, encoding, buffer.length);
  }

  NodeFrame _readResponse(
      String connectionId, List<int> bytes, String encoding, int remaining) {
    final data = encoding == 'base64'
        ? base64Encode(bytes)
        : utf8.decode(bytes, allowMalformed: true);
    return NodeFrame.response('', payload: {
      'connectionId': connectionId,
      'data': data,
      'encoding': encoding,
      'bytesRead': bytes.length,
      'bufferRemaining': remaining,
    });
  }

  // ── disconnect ──────────────────────────────────────────────────────────

  Future<NodeFrame> _disconnect(Map<String, dynamic> params) async {
    final connectionId = params['connectionId'] as String?;
    if (connectionId == null) {
      return _error('MISSING_PARAM', 'connectionId required');
    }

    if (connectionId == 'all') {
      await _disconnectUsb();
      await _disconnectBt();
      return NodeFrame.response('', payload: {
        'connectionId': 'all',
        'disconnected': true,
      });
    }

    if (connectionId == _usbConnectionId) {
      await _disconnectUsb();
      return NodeFrame.response('', payload: {
        'connectionId': connectionId,
        'disconnected': true,
      });
    }

    if (connectionId == _btConnectionId) {
      await _disconnectBt();
      return NodeFrame.response('', payload: {
        'connectionId': connectionId,
        'disconnected': true,
      });
    }

    return _error('NOT_CONNECTED', 'No connection: $connectionId');
  }

  Future<void> _disconnectUsb() async {
    _usbDataSub?.cancel();
    _usbDataSub = null;
    try {
      await _usbSerial.disconnect();
    } catch (_) {}
    _usbConnectionId = null;
    _usbDeviceName = null;
    _usbBuffer = null;
  }

  Future<void> _disconnectBt() async {
    _btDataSub?.cancel();
    _btDataSub = null;
    try {
      await _btSerial.disconnect();
    } catch (_) {}
    _btConnectionId = null;
    _btDeviceName = null;
    _btAddress = null;
    _btBuffer = null;
  }

  // ── list ────────────────────────────────────────────────────────────────

  NodeFrame _list() {
    final connections = <Map<String, dynamic>>[];
    if (_usbConnectionId != null) {
      connections.add({
        'connectionId': _usbConnectionId,
        'transport': 'usb',
        'device': _usbDeviceName,
        'bufferBytes': _usbBuffer?.length ?? 0,
      });
    }
    if (_btConnectionId != null) {
      connections.add({
        'connectionId': _btConnectionId,
        'transport': 'bluetooth',
        'device': _btDeviceName,
        'address': _btAddress,
        'bufferBytes': _btBuffer?.length ?? 0,
      });
    }
    return NodeFrame.response('', payload: {'connections': connections});
  }

  // ── helpers ─────────────────────────────────────────────────────────────

  NodeFrame _error(String code, String message) {
    return NodeFrame.response('', error: {'code': code, 'message': message});
  }

  void dispose() {
    _usbDataSub?.cancel();
    _btDataSub?.cancel();
    try {
      _usbSerial.disconnect();
    } catch (_) {}
    try {
      _btSerial.disconnect();
    } catch (_) {}
    _usbConnectionId = null;
    _btConnectionId = null;
    _usbBuffer = null;
    _btBuffer = null;
  }
}
