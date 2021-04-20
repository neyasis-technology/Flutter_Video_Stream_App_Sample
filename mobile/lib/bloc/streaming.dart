import 'dart:typed_data';

import 'package:video_streaming_mobile/components/modals/call_incoming.dart';
import 'package:video_streaming_mobile/components/modals/call_outgoing.dart';
import 'package:video_streaming_mobile/constants/application.dart';
import 'package:video_streaming_mobile/constants/call_type.dart';
import 'package:video_streaming_mobile/constants/socket_events.dart';
import 'package:video_streaming_mobile/extensions/socket.io.dart';
import 'package:video_streaming_mobile/models/streaming/store.dart';
import 'package:video_streaming_mobile/repository/bloc.dart';

class StreamingBloc extends BlocRepository<StreamingBM, StreamingBM> {
  @override
  Future process(String lastRequestUniqueId) async {
    StreamingBM requestObject = this.requestObject!;
    if (requestObject.callType == CallType.outgoing) {
      CallOutgoingDialog.show(Application.context, requestObject.name);
    } else {
      CallIncomingDialog.show(Application.context, requestObject.name);
    }
    this.fetcherSink(this.requestObject!, lastRequestUniqueId: lastRequestUniqueId);
  }

  stopRinging() {
    StreamingBM tempStore = this.store!;
    tempStore.isRinging = false;
    this.fetcherSink(tempStore, lastRequestUniqueId: null, forceSink: true);
  }
}

StreamingBloc streamingBloc = StreamingBloc();
