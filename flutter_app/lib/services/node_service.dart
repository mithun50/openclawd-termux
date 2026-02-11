import 'dart:async';
import '../constants.dart';
import '../models/node_frame.dart';
import '../models/node_state.dart';
import 'native_bridge.dart';
import 'node_identity_service.dart';
import 'node_ws_service.dart';
import 'preferences_service.dart';

class NodeService {
  final NodeIdentityService _identity = NodeIdentityService();
  final NodeWsService _ws = NodeWsService();
  final _stateController = StreamController<NodeState>.broadcast();
  StreamSubscription? _frameSubscription;

  NodeState _state = const NodeState();
  final Map<String, Future<NodeFrame> Function(String, Map<String, dynamic>)>
      _capabilityHandlers = {};

  Stream<NodeState> get stateStream => _stateController.stream;
  NodeState get state => _state;

  void _updateState(NodeState newState) {
    _state = newState;
    _stateController.add(_state);
  }

  void _log(String message) {
    final logs = [..._state.logs, message];
    if (logs.length > 500) {
      logs.removeRange(0, logs.length - 500);
    }
    _updateState(_state.copyWith(logs: logs));
  }

  void registerCapability(
      String name,
      List<String> commands,
      Future<NodeFrame> Function(String command, Map<String, dynamic> params)
          handler) {
    for (final cmd in commands) {
      _capabilityHandlers['$name.$cmd'] = handler;
    }
  }

  Future<void> init() async {
    await _identity.init();
    _updateState(_state.copyWith(deviceId: _identity.deviceId));
    _log('[NODE] Device ID: ${_identity.deviceId.substring(0, 12)}...');
  }

  Future<void> connect({String? host, int? port}) async {
    final prefs = PreferencesService();
    await prefs.init();

    final targetHost = host ?? prefs.nodeGatewayHost ?? AppConstants.gatewayHost;
    final targetPort = port ?? prefs.nodeGatewayPort ?? AppConstants.gatewayPort;

    _updateState(_state.copyWith(
      status: NodeStatus.connecting,
      clearError: true,
      gatewayHost: targetHost,
      gatewayPort: targetPort,
    ));
    _log('[NODE] Connecting to $targetHost:$targetPort...');

    _frameSubscription?.cancel();
    _frameSubscription = _ws.frameStream.listen(_onFrame);

    try {
      await _ws.connect(targetHost, targetPort);
      _log('[NODE] WebSocket connected, awaiting challenge...');
    } catch (e) {
      _updateState(_state.copyWith(
        status: NodeStatus.error,
        errorMessage: 'Connection failed: $e',
      ));
      _log('[NODE] Connection failed: $e');
    }
  }

  void _onFrame(NodeFrame frame) {
    if (frame.isEvent) {
      _handleEvent(frame);
    } else if (frame.isRequest) {
      _handleInvoke(frame);
    }
  }

  Future<void> _handleEvent(NodeFrame frame) async {
    switch (frame.event) {
      case '_disconnected':
        if (_state.status != NodeStatus.disabled) {
          _updateState(_state.copyWith(
            status: NodeStatus.disconnected,
            clearConnectedAt: true,
          ));
          _log('[NODE] Disconnected, will retry...');
        }
        break;

      case 'challenge':
        _updateState(_state.copyWith(status: NodeStatus.challenging));
        final nonce = frame.data?['nonce'] as String?;
        if (nonce == null) {
          _log('[NODE] Challenge missing nonce');
          return;
        }
        _log('[NODE] Challenge received, signing...');
        try {
          final signature = await _identity.signChallenge(nonce);
          final prefs = PreferencesService();
          await prefs.init();
          final token = prefs.nodeDeviceToken;

          final connectFrame = NodeFrame.request('node.connect', {
            'deviceId': _identity.deviceId,
            'signature': signature,
            'role': AppConstants.nodeRole,
            if (token != null) 'token': token,
          });
          final response = await _ws.sendRequest(connectFrame);

          if (response.isError) {
            final code = response.error?['code'];
            if (code == 'TOKEN_INVALID' || code == 'NOT_PAIRED') {
              _log('[NODE] Token invalid or not paired, requesting pairing...');
              await _requestPairing();
            } else {
              _updateState(_state.copyWith(
                status: NodeStatus.error,
                errorMessage: response.error?['message'] as String? ?? 'Connect failed',
              ));
              _log('[NODE] Connect error: ${response.error}');
            }
          } else {
            _onConnected(response);
          }
        } catch (e) {
          _log('[NODE] Challenge/connect error: $e');
          _updateState(_state.copyWith(
            status: NodeStatus.error,
            errorMessage: '$e',
          ));
        }
        break;

      case 'hello-ok':
        _onConnected(frame);
        break;
    }
  }

  void _onConnected(NodeFrame frame) {
    _updateState(_state.copyWith(
      status: NodeStatus.paired,
      connectedAt: DateTime.now(),
      clearPairingCode: true,
    ));
    _log('[NODE] Paired and connected');

    // Send capabilities advertisement
    final capabilities = _capabilityHandlers.keys.toList();
    _ws.send(NodeFrame.event('node.capabilities', {
      'deviceId': _identity.deviceId,
      'capabilities': capabilities,
    }));
  }

  Future<void> _requestPairing() async {
    _updateState(_state.copyWith(status: NodeStatus.pairing));
    _log('[NODE] Requesting pairing...');

    try {
      final pairReq = NodeFrame.request('node.pair.request', {
        'deviceId': _identity.deviceId,
      });
      final response = await _ws.sendRequest(
        pairReq,
        timeout: Duration(milliseconds: AppConstants.pairingTimeoutMs),
      );

      if (response.isError) {
        _updateState(_state.copyWith(
          status: NodeStatus.error,
          errorMessage: response.error?['message'] as String? ?? 'Pairing failed',
        ));
        _log('[NODE] Pairing error: ${response.error}');
        return;
      }

      final code = response.result?['code'] as String?;
      final token = response.result?['token'] as String?;

      if (token != null) {
        // Already approved (auto-pair flow)
        final prefs = PreferencesService();
        await prefs.init();
        prefs.nodeDeviceToken = token;
        _log('[NODE] Pairing approved, token received');
        // Reconnect with token
        await Future.delayed(const Duration(milliseconds: 500));
        await _ws.disconnect();
        await connect();
        return;
      }

      if (code != null) {
        _updateState(_state.copyWith(pairingCode: code));
        _log('[NODE] Pairing code: $code');

        // Auto-approve if connecting to localhost
        final isLocal = _state.gatewayHost == '127.0.0.1' ||
            _state.gatewayHost == 'localhost';
        if (isLocal) {
          _log('[NODE] Local gateway detected, auto-approving...');
          try {
            await NativeBridge.runInProot('openclaw nodes approve $code');
            _log('[NODE] Auto-approve command sent');
            // Wait for gateway to process approval
            await Future.delayed(const Duration(milliseconds: 500));
            await _ws.disconnect();
            await connect();
          } catch (e) {
            _log('[NODE] Auto-approve failed: $e (user must approve manually)');
          }
        }
      }
    } catch (e) {
      _updateState(_state.copyWith(
        status: NodeStatus.error,
        errorMessage: 'Pairing timeout: $e',
      ));
      _log('[NODE] Pairing failed: $e');
    }
  }

  Future<void> _handleInvoke(NodeFrame frame) async {
    final method = frame.method;
    if (method == null || frame.id == null) return;

    _log('[NODE] Invoke: $method');
    final handler = _capabilityHandlers[method];
    if (handler == null) {
      _ws.send(NodeFrame.response(frame.id!, error: {
        'code': 'NOT_SUPPORTED',
        'message': 'Capability $method not available',
      }));
      return;
    }

    try {
      final result = await handler(method, frame.params ?? {});
      if (result.isError) {
        _ws.send(NodeFrame.response(frame.id!, error: result.error));
      } else {
        _ws.send(NodeFrame.response(frame.id!, result: result.result));
      }
    } catch (e) {
      _ws.send(NodeFrame.response(frame.id!, error: {
        'code': 'INVOKE_ERROR',
        'message': '$e',
      }));
    }
  }

  Future<void> disconnect() async {
    _frameSubscription?.cancel();
    await _ws.disconnect();
    _updateState(_state.copyWith(
      status: NodeStatus.disconnected,
      clearConnectedAt: true,
      clearPairingCode: true,
    ));
    _log('[NODE] Disconnected');
  }

  Future<void> disable() async {
    await disconnect();
    _updateState(NodeState(
      status: NodeStatus.disabled,
      logs: _state.logs,
      deviceId: _state.deviceId,
    ));
    _log('[NODE] Node disabled');
  }

  void dispose() {
    _frameSubscription?.cancel();
    _ws.dispose();
    _stateController.close();
  }
}
