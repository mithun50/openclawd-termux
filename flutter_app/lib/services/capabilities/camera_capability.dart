import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/node_frame.dart';
import 'capability_handler.dart';

class CameraCapability extends CapabilityHandler {
  List<CameraDescription>? _cameras;

  @override
  String get name => 'camera';

  @override
  List<String> get commands => ['snap', 'clip', 'list'];

  @override
  List<Permission> get requiredPermissions => [Permission.camera];

  @override
  Future<bool> checkPermission() async {
    return await Permission.camera.isGranted;
  }

  @override
  Future<bool> requestPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Create a fresh controller for each operation. The caller MUST dispose it
  /// when done so the camera hardware is released immediately.
  Future<CameraController> _createController({String? facing}) async {
    _cameras ??= await availableCameras();
    if (_cameras!.isEmpty) throw Exception('No camera available');

    final direction = facing == 'front'
        ? CameraLensDirection.front
        : CameraLensDirection.back;
    final target = _cameras!.firstWhere(
      (c) => c.lensDirection == direction,
      orElse: () => _cameras!.first,
    );

    final controller = CameraController(target, ResolutionPreset.medium);
    await controller.initialize();
    return controller;
  }

  @override
  Future<NodeFrame> handle(String command, Map<String, dynamic> params) async {
    switch (command) {
      case 'camera.snap':
        return _snap(params);
      case 'camera.clip':
        return _clip(params);
      case 'camera.list':
        return _list();
      default:
        return NodeFrame.response('', error: {
          'code': 'UNKNOWN_COMMAND',
          'message': 'Unknown camera command: $command',
        });
    }
  }

  Future<NodeFrame> _list() async {
    try {
      _cameras ??= await availableCameras();
      final cameraList = _cameras!.map((c) => {
        'id': c.name,
        'facing': c.lensDirection == CameraLensDirection.front ? 'front' : 'back',
      }).toList();
      return NodeFrame.response('', payload: {
        'cameras': cameraList,
      });
    } catch (e) {
      return NodeFrame.response('', error: {
        'code': 'CAMERA_ERROR',
        'message': '$e',
      });
    }
  }

  Future<NodeFrame> _snap(Map<String, dynamic> params) async {
    CameraController? controller;
    try {
      final facing = params['facing'] as String?;
      controller = await _createController(facing: facing);

      // Brief settle time for auto-exposure/focus
      await Future.delayed(const Duration(milliseconds: 500));

      final file = await controller.takePicture();
      final bytes = await File(file.path).readAsBytes();
      final b64 = base64Encode(bytes);

      // Get image dimensions
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final width = frame.image.width;
      final height = frame.image.height;
      frame.image.dispose();

      // Clean up temp file
      await File(file.path).delete().catchError((_) => File(file.path));
      return NodeFrame.response('', payload: {
        'base64': b64,
        'format': 'jpg',
        'width': width,
        'height': height,
      });
    } catch (e) {
      return NodeFrame.response('', error: {
        'code': 'CAMERA_ERROR',
        'message': '$e',
      });
    } finally {
      // Always release the camera
      await controller?.dispose();
    }
  }

  Future<NodeFrame> _clip(Map<String, dynamic> params) async {
    CameraController? controller;
    try {
      final durationMs = params['durationMs'] as int? ?? 5000;
      final facing = params['facing'] as String?;
      controller = await _createController(facing: facing);
      await controller.startVideoRecording();
      await Future.delayed(Duration(milliseconds: durationMs));
      final file = await controller.stopVideoRecording();
      final bytes = await File(file.path).readAsBytes();
      final b64 = base64Encode(bytes);
      await File(file.path).delete().catchError((_) => File(file.path));
      return NodeFrame.response('', payload: {
        'base64': b64,
        'format': 'mp4',
        'durationMs': durationMs,
        'hasAudio': false,
      });
    } catch (e) {
      return NodeFrame.response('', error: {
        'code': 'CAMERA_ERROR',
        'message': '$e',
      });
    } finally {
      // Always release the camera
      await controller?.dispose();
    }
  }

  void dispose() {
    // No persistent controller to clean up anymore
  }
}
