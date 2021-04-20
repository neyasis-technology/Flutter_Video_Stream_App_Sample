import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_streaming_mobile/bloc/streaming.dart';
import 'package:video_streaming_mobile/bloc/user_list.dart';
import 'package:video_streaming_mobile/constants/call_type.dart';
import 'package:video_streaming_mobile/constants/socket_events.dart';
import 'package:video_streaming_mobile/extensions/socket.io.dart';
import 'package:video_streaming_mobile/models/streaming/store.dart';
import 'package:video_streaming_mobile/models/user/response.dart';
import 'package:video_streaming_mobile/screens/video_streaming.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    userListBloc.call();
    super.initState();
  }

  Widget userCard(UserResponseBM user) {
    return Material(
      color: Colors.grey[100],
      child: InkWell(
        onTap: () {
          streamingBloc.call(
            requestObject: StreamingBM(
              name: user.name,
              callType: CallType.outgoing,
              isRinging: true,
            ),
          );
          IO.socket!.emit(SocketEvents.callUser.value, user.name);
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 25, top: 25, right: 15, left: 15),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(user.name),
              ),
              Icon(Icons.chevron_right_sharp, color: Colors.grey, size: 25),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sample Video Streaming App")),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text("CONNECTED USERS"),
            SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () async => userListBloc.call(),
                child: StreamBuilder(
                  stream: userListBloc.stream,
                  builder: (_, __) {
                    return ListView.builder(
                      itemCount: userListBloc.store!.length,
                      itemBuilder: (_, index) => userCard(userListBloc.store![index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
