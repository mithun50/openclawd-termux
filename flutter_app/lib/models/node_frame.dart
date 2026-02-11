import 'dart:convert';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class NodeFrame {
  final String type; // 'request', 'response', 'event'
  final String? id;
  final String? method;
  final Map<String, dynamic>? params;
  final Map<String, dynamic>? result;
  final Map<String, dynamic>? error;
  final String? event;
  final Map<String, dynamic>? data;

  const NodeFrame({
    required this.type,
    this.id,
    this.method,
    this.params,
    this.result,
    this.error,
    this.event,
    this.data,
  });

  factory NodeFrame.request(String method, [Map<String, dynamic>? params]) {
    return NodeFrame(
      type: 'request',
      id: _uuid.v4(),
      method: method,
      params: params ?? {},
    );
  }

  factory NodeFrame.response(String id, {Map<String, dynamic>? result, Map<String, dynamic>? error}) {
    return NodeFrame(
      type: 'response',
      id: id,
      result: result,
      error: error,
    );
  }

  factory NodeFrame.event(String event, [Map<String, dynamic>? data]) {
    return NodeFrame(
      type: 'event',
      event: event,
      data: data,
    );
  }

  factory NodeFrame.fromJson(Map<String, dynamic> json) {
    return NodeFrame(
      type: json['type'] as String? ?? 'response',
      id: json['id'] as String?,
      method: json['method'] as String?,
      params: json['params'] != null
          ? Map<String, dynamic>.from(json['params'] as Map)
          : null,
      result: json['result'] != null
          ? Map<String, dynamic>.from(json['result'] as Map)
          : null,
      error: json['error'] != null
          ? Map<String, dynamic>.from(json['error'] as Map)
          : null,
      event: json['event'] as String?,
      data: json['data'] != null
          ? Map<String, dynamic>.from(json['data'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'type': type};
    if (id != null) map['id'] = id;
    if (method != null) map['method'] = method;
    if (params != null) map['params'] = params;
    if (result != null) map['result'] = result;
    if (error != null) map['error'] = error;
    if (event != null) map['event'] = event;
    if (data != null) map['data'] = data;
    return map;
  }

  String encode() => jsonEncode(toJson());

  static NodeFrame decode(String raw) =>
      NodeFrame.fromJson(jsonDecode(raw) as Map<String, dynamic>);

  bool get isRequest => type == 'request';
  bool get isResponse => type == 'response';
  bool get isEvent => type == 'event';
  bool get isError => error != null;
}
