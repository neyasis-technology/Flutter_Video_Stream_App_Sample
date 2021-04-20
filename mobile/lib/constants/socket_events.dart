enum SocketEvents {
  callUser,
  incomingCall,
  callAccepted,
  acceptCall,
  closeCall,
  callClosed, //TODO:: burada kaldık
  register,
  streamData,
  userList,
}

extension SocketEventsExtension on SocketEvents {
  String get value {
    switch (this) {
      case SocketEvents.register:
        return "REGISTER";
      case SocketEvents.streamData:
        return "STREAM_DATA";
      case SocketEvents.userList:
        return "USER_LIST";
      case SocketEvents.callUser:
        return "CALL_USER";
      case SocketEvents.incomingCall:
        return "INCOMING_CALL";
      case SocketEvents.callClosed:
        return "CALL_CLOSED";
      case SocketEvents.callAccepted:
        return "CALL_ACCEPTED";
      case SocketEvents.acceptCall:
        return "ACCEPT_CALL";
      case SocketEvents.closeCall:
        return "CLOSE_CALL";
      default:
        return "";
    }
  }
}
