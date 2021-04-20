import 'package:flutter/material.dart';
import 'package:video_streaming_mobile/constants/application.dart';
import 'package:video_streaming_mobile/extensions/socket.io.dart';
import 'package:video_streaming_mobile/screens/register.dart';

void main() {
  IO.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: Application.navigatorKey,
      home: RegisterScreen(),
    );
  }
}
