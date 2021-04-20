import 'package:flutter/material.dart';

class Application {
  static GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  static String socketUrl = "http://192.168.168.3:2021";
  static get context => navigatorKey.currentContext;
}
