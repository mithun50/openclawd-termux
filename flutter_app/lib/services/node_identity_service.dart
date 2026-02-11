import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NodeIdentityService {
  static const _keyPrivate = 'node_ed25519_private';
  static const _keyPublic = 'node_ed25519_public';
  static const _keyDeviceId = 'node_device_id';

  late SimpleKeyPair _keyPair;
  late String _deviceId;

  String get deviceId => _deviceId;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPrivate = prefs.getString(_keyPrivate);
    final storedPublic = prefs.getString(_keyPublic);
    final storedDeviceId = prefs.getString(_keyDeviceId);

    if (storedPrivate != null && storedPublic != null && storedDeviceId != null) {
      final privateBytes = base64Decode(storedPrivate);
      final publicBytes = base64Decode(storedPublic);
      _keyPair = SimpleKeyPairData(
        privateBytes,
        publicKey: SimplePublicKey(publicBytes, type: KeyPairType.ed25519),
        type: KeyPairType.ed25519,
      );
      _deviceId = storedDeviceId;
    } else {
      await _generateAndStore(prefs);
    }
  }

  Future<void> _generateAndStore(SharedPreferences prefs) async {
    final algorithm = Ed25519();
    final newKeyPair = await algorithm.newKeyPair();
    _keyPair = await newKeyPair.extract();

    final publicKey = await _keyPair.extractPublicKey();
    final publicBytes = Uint8List.fromList(publicKey.bytes);

    // deviceId = SHA-256 hex of raw 32-byte public key
    final hash = await Sha256().hash(publicBytes);
    _deviceId = hash.bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();

    final privateBytes = await _keyPair.extractPrivateKeyBytes();
    await prefs.setString(_keyPrivate, base64Encode(privateBytes));
    await prefs.setString(_keyPublic, base64Encode(publicBytes));
    await prefs.setString(_keyDeviceId, _deviceId);
  }

  /// Sign a challenge nonce (hex string) with Ed25519 private key.
  /// Returns base64-encoded signature.
  Future<String> signChallenge(String nonceHex) async {
    final nonceBytes = _hexToBytes(nonceHex);
    final algorithm = Ed25519();
    final signature = await algorithm.sign(nonceBytes, keyPair: _keyPair);
    return base64Encode(signature.bytes);
  }

  static Uint8List _hexToBytes(String hex) {
    final result = Uint8List(hex.length ~/ 2);
    for (var i = 0; i < hex.length; i += 2) {
      result[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
    }
    return result;
  }
}
