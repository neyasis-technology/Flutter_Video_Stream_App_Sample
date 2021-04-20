import 'dart:convert';

import 'package:video_streaming_mobile/constants/socket_events.dart';
import 'package:video_streaming_mobile/extensions/socket.io.dart';
import 'package:video_streaming_mobile/models/user/response.dart';
import 'package:video_streaming_mobile/repository/bloc.dart';

class UserListBloc extends BlocRepository<Null, List<UserResponseBM>> {
  UserListBloc() {
    this.setStore(<UserResponseBM>[]);
  }

  @override
  Future process(String lastRequestUniqueId) async {
    if (IO.socket == null || !IO.socket!.connected) {
      return this.fetcherSink(<UserResponseBM>[], lastRequestUniqueId: lastRequestUniqueId);
    }
    IO.socket!.emitWithAck(SocketEvents.userList.value, null, ack: (responseJson) {
      List<UserResponseBM> response = jsonDecode(responseJson)
          .map((dynamic user) {
           print(user);
            return UserResponseBM.fromJSON(user);
          })
          .cast<UserResponseBM>()
          .toList();
      this.fetcherSink(
        response.where((element) => element.clientId != IO.socket!.id).toList(),
        lastRequestUniqueId: lastRequestUniqueId,
      );
    });
  }
}

UserListBloc userListBloc = UserListBloc();
