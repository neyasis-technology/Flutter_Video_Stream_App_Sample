import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_streaming_mobile/bloc/streaming.dart';
import 'package:video_streaming_mobile/constants/application.dart';
import 'package:video_streaming_mobile/constants/socket_events.dart';
import 'package:video_streaming_mobile/extensions/socket.io.dart';
import 'package:video_streaming_mobile/screens/video_streaming.dart';

class CallIncomingDialog {
  static show(BuildContext context, String name) {
    if (context == null) throw ("Context can not be null");
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: _CallIncomingDialogContainer(name),
        );
      },
    );
  }
}

void onAcccept() {
  IO.socket!.emit(SocketEvents.acceptCall.value, streamingBloc.store!.name);
  Navigator.of(Application.context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => VideoStreamingScreen()),
    (route) => false,
  );
}

void onDontAccept() {
  IO.socket!.emit(SocketEvents.closeCall.value, streamingBloc.store!.name);
  Navigator.of(Application.context).pop();
}

class _CallIncomingDialogContainer extends StatelessWidget {
  String name;

  _CallIncomingDialogContainer(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 175,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 15),
          Text(name, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
          SizedBox(height: 15),
          Text("is calling you", style: TextStyle(fontSize: 18)),
          SizedBox(height: 15),
          Row(children: [
            SizedBox(width: 5),
            Expanded(child: MaterialButton(onPressed: onDontAccept, child: Text("DON'T ACCEPT"), color: Colors.red, textColor: Colors.white)),
            SizedBox(width: 10),
            Expanded(child: MaterialButton(onPressed: onAcccept, child: Text("ACCEPT"), color: Colors.green, textColor: Colors.white)),
            SizedBox(width: 5),
          ]),
        ],
      ),
    );
  }
}
