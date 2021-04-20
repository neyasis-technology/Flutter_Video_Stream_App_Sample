import 'dart:typed_data';

import 'package:video_streaming_mobile/constants/call_type.dart';

class StreamingBM {
  bool isRinging;
  CallType callType;
  String name;

  Uint8List? lastFrame = null;

  StreamingBM({required this.isRinging, required this.callType, required this.name});
}
