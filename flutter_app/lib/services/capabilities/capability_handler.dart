import '../../models/node_frame.dart';

abstract class CapabilityHandler {
  String get name;
  List<String> get commands;

  Future<NodeFrame> handle(String command, Map<String, dynamic> params);
  Future<bool> checkPermission();
  Future<bool> requestPermission();

  /// Ensures permission is granted before handling. Returns error frame if denied.
  Future<NodeFrame> handleWithPermission(
      String command, Map<String, dynamic> params) async {
    if (!await checkPermission()) {
      final granted = await requestPermission();
      if (!granted) {
        return NodeFrame.response('', error: {
          'code': 'PERMISSION_DENIED',
          'message': '$name permission not granted',
        });
      }
    }
    return handle(command, params);
  }
}
