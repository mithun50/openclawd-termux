import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/gateway_state.dart';
import '../models/node_state.dart';
import '../services/capabilities/camera_capability.dart';
import '../services/capabilities/canvas_capability.dart';
import '../services/capabilities/location_capability.dart';
import '../services/capabilities/screen_capability.dart';
import '../services/node_service.dart';
import '../services/preferences_service.dart';


class NodeProvider extends ChangeNotifier {
  final NodeService _nodeService = NodeService();
  StreamSubscription? _subscription;
  NodeState _state = const NodeState();
  GatewayState? _lastGatewayState;

  // Capabilities (only those in gateway's Android command policy)
  final _cameraCapability = CameraCapability();
  final _canvasCapability = CanvasCapability();
  final _locationCapability = LocationCapability();
  final _screenCapability = ScreenCapability();

  NodeState get state => _state;

  NodeProvider() {
    _subscription = _nodeService.stateStream.listen((state) {
      _state = state;
      notifyListeners();
    });
    _registerCapabilities();
    _init();
  }

  void _registerCapabilities() {
    // Only register capabilities in the gateway's Android command policy
    // (see node-command-policy.js PLATFORM_DEFAULTS.android)
    _nodeService.registerCapability(
      _cameraCapability.name,
      _cameraCapability.commands.map((c) => '${_cameraCapability.name}.$c').toList(),
      (cmd, params) => _cameraCapability.handleWithPermission(cmd, params),
    );
    _nodeService.registerCapability(
      _canvasCapability.name,
      _canvasCapability.commands.map((c) => '${_canvasCapability.name}.$c').toList(),
      (cmd, params) => _canvasCapability.handle(cmd, params),
    );
    _nodeService.registerCapability(
      _locationCapability.name,
      _locationCapability.commands.map((c) => '${_locationCapability.name}.$c').toList(),
      (cmd, params) => _locationCapability.handleWithPermission(cmd, params),
    );
    _nodeService.registerCapability(
      _screenCapability.name,
      _screenCapability.commands.map((c) => '${_screenCapability.name}.$c').toList(),
      (cmd, params) => _screenCapability.handle(cmd, params),
    );
  }

  Future<void> _init() async {
    await _nodeService.init();
    final prefs = PreferencesService();
    await prefs.init();
    if (prefs.nodeEnabled) {
      await _nodeService.connect();
    }
  }

  void onGatewayStateChanged(GatewayState gatewayState) {
    final wasRunning = _lastGatewayState?.isRunning ?? false;
    final isRunning = gatewayState.isRunning;
    _lastGatewayState = gatewayState;

    if (!wasRunning && isRunning && _state.isDisabled) {
      // Gateway just started - auto-enable node if previously enabled
      _checkAutoConnect();
    } else if (wasRunning && !isRunning && !_state.isDisabled) {
      // Gateway stopped - disconnect node
      _nodeService.disconnect();
    }
  }

  Future<void> _checkAutoConnect() async {
    final prefs = PreferencesService();
    await prefs.init();
    if (prefs.nodeEnabled) {
      await _nodeService.connect();
    }
  }

  Future<void> enable() async {
    final prefs = PreferencesService();
    await prefs.init();
    prefs.nodeEnabled = true;
    await _nodeService.connect();
  }

  Future<void> disable() async {
    final prefs = PreferencesService();
    await prefs.init();
    prefs.nodeEnabled = false;
    await _nodeService.disable();
  }

  Future<void> connectRemote(String host, int port, {String? token}) async {
    final prefs = PreferencesService();
    await prefs.init();
    prefs.nodeGatewayHost = host;
    prefs.nodeGatewayPort = port;
    prefs.nodeGatewayToken = token;
    prefs.nodeEnabled = true;
    // Clear cached token so it re-reads on next connect
    _nodeService.clearCachedToken();
    await _nodeService.connect(host: host, port: port);
  }

  Future<void> reconnect() async {
    await _nodeService.disconnect();
    await _nodeService.connect();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _nodeService.dispose();
    _cameraCapability.dispose();
    super.dispose();
  }
}
