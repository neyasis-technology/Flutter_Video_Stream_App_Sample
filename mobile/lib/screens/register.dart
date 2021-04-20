import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_streaming_mobile/components/modals/call_incoming.dart';
import 'package:video_streaming_mobile/components/modals/call_outgoing.dart';
import 'package:video_streaming_mobile/constants/socket_events.dart';
import 'package:video_streaming_mobile/extensions/socket.io.dart';
import 'package:video_streaming_mobile/screens/users.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String name = "";

  onRegister() {
    if (IO.socket == null) {
      Fluttertoast.showToast(
        msg: "Please run socket server. Socket is not available",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    if (name.length < 3) {
      return Fluttertoast.showToast(
        msg: "Your name must be minimum 3 character",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    IO.socket!.emit(SocketEvents.register.value, [name, IO.socket!.id]);
    IO.username = name;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => UsersScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sample Video Streaming App")),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              decoration: (InputDecoration(hintText: "Set Your Name")),
              onChanged: (value) => this.setState(() => this.name = value),
            ),
            MaterialButton(
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: onRegister,
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
