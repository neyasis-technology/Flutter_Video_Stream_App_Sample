import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CallOutgoingDialog {
  static show(BuildContext context, String name) {
    if (context == null) throw ("Context can not be null");
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: _CallOutgoingDialogContainer(name),
        );
      },
    );
  }
}

class _CallOutgoingDialogContainer extends StatelessWidget {
  String name;

  _CallOutgoingDialogContainer(this.name);

  void onCancel(context) {
    Navigator.of(context).pop();
  }

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
          Text("is calling", style: TextStyle(fontSize: 18)),
          SizedBox(height: 15),
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width * 0.70,
            onPressed: () => onCancel(context),
            child: Text("CANCEL"),
            color: Colors.red,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
