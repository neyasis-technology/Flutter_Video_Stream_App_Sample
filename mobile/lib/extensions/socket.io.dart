import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IOClient;
import 'package:video_streaming_mobile/bloc/streaming.dart';
import 'package:video_streaming_mobile/constants/application.dart';
import 'package:video_streaming_mobile/constants/call_type.dart';
import 'package:video_streaming_mobile/constants/socket_events.dart';
import 'package:video_streaming_mobile/models/streaming/store.dart';
import 'package:video_streaming_mobile/screens/users.dart';
import 'package:video_streaming_mobile/screens/video_streaming.dart';

class IO {
  static IOClient.Socket? _socket = null;

  static IOClient.Socket? get socket => _socket;
  static String? _username = null;
  static bool isConnected = false;

  static set username(String username) => _username = username;

  static initialize() {
    _socket = IOClient.io(
      Application.socketUrl,
      IOClient.OptionBuilder().setTransports(['websocket']).build(),
    );
    _socket!.onConnectError((data) => print("SOCKET CONNECT ERROR!"));
    _socket!.onConnect((_) {
      if (_username != null) _socket!.emit(SocketEvents.register.value, [_username, _socket!.id]);
      isConnected = true;
    });
    _socket!.onDisconnect((_) => isConnected = false);
    _socket!.on(SocketEvents.streamData.value, streamData);
    _socket!.on(SocketEvents.incomingCall.value, incomingCall);
    _socket!.on(SocketEvents.callAccepted.value, callAccepted);
    _socket!.on(SocketEvents.callClosed.value, callClosed);
  }

  static streamData(data) {
    StreamingBM tempStore = streamingBloc.store!;
    tempStore.lastFrame = Uint8List.fromList(data);
    streamingBloc.fetcherSink(tempStore, lastRequestUniqueId: null, forceSink: true);
  }

  static incomingCall(from) {
    streamingBloc.call(
      requestObject: StreamingBM(
        name: from,
        callType: CallType.incoming,
        isRinging: true,
      ),
    );
  }

  static callClosed(from) {
    Navigator.of(Application.context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => UsersScreen()),
      (route) => false,
    );
  }

  static callAccepted(from) {
    streamingBloc.stopRinging();
    Navigator.of(Application.context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => VideoStreamingScreen()),
      (route) => false,
    );
  }
}
