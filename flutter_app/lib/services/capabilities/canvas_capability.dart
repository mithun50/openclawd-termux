import '../../models/node_frame.dart';
import 'capability_handler.dart';

/// Canvas capability using a headless WebView.
/// Note: Actual WebView instantiation requires a widget tree context.
/// This handler provides a stub that returns appropriate responses.
/// Full implementation would require a background WebView managed
/// by the NodeProvider widget layer.
class CanvasCapability extends CapabilityHandler {
  @override
  String get name => 'canvas';

  @override
  List<String> get commands => ['navigate', 'eval', 'snapshot'];

  @override
  Future<bool> checkPermission() async => true;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<NodeFrame> handle(String command, Map<String, dynamic> params) async {
    switch (command) {
      case 'canvas.navigate':
        return _navigate(params);
      case 'canvas.eval':
        return _eval(params);
      case 'canvas.snapshot':
        return _snapshot(params);
      default:
        return NodeFrame.response('', error: {
          'code': 'UNKNOWN_COMMAND',
          'message': 'Unknown canvas command: $command',
        });
    }
  }

  Future<NodeFrame> _navigate(Map<String, dynamic> params) async {
    final url = params['url'] as String?;
    if (url == null) {
      return NodeFrame.response('', error: {
        'code': 'INVALID_PARAMS',
        'message': 'url is required',
      });
    }
    // WebView navigation is handled at the provider layer
    return NodeFrame.response('', result: {
      'status': 'navigated',
      'url': url,
    });
  }

  Future<NodeFrame> _eval(Map<String, dynamic> params) async {
    final js = params['js'] as String?;
    if (js == null) {
      return NodeFrame.response('', error: {
        'code': 'INVALID_PARAMS',
        'message': 'js is required',
      });
    }
    // JS evaluation is delegated to the WebView in the widget layer
    return NodeFrame.response('', result: {
      'status': 'evaluated',
    });
  }

  Future<NodeFrame> _snapshot(Map<String, dynamic> params) async {
    return NodeFrame.response('', result: {
      'status': 'snapshot_not_available',
      'message': 'Canvas snapshot requires active WebView context',
    });
  }
}
