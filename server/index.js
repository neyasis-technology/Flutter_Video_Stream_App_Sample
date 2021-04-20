const Express = require('express');
const App = Express();
const Server = require('http').createServer(App);
const IO = require('socket.io')(Server, {
  pingInterval: 1000,
  pingTimeout: 10000,
  cors: { origin: '*' },
});
const { AppConstants } = require('./constants/app');
const { SocketEvents } = require('./constants/socket_events');
IO.on('connection', (socket) => {
  console.log(`AN USER CONNECTED ON SOCKET. SOCKET ID is '${socket.id}'`);
  socket.on(SocketEvents.register, (name, clientId) => {
    socket.name = name;
    socket.clientId = clientId;
  });
  socket.on(SocketEvents.userList, (callback) => {
    const users = [];
    IO.sockets.sockets.forEach((connectedSocket) => {
      if (connectedSocket?.name) {
        users.push({
          id: connectedSocket.id,
          name: connectedSocket.name,
          clientId: connectedSocket.clientId,
        });
      }
    });
    callback(JSON.stringify(users));
  });
  socket.on(SocketEvents.streamData, async (data, callback) => {
    IO.sockets.sockets.forEach((connectedSocket) => {
      if (connectedSocket?.name === data.to) {
        connectedSocket.emit(SocketEvents.streamData, data.bytes);
        callback();
      }
    });
  });
  socket.on(SocketEvents.callUser, (name) => {
    IO.sockets.sockets.forEach((connectedSocket) => {
      if (connectedSocket?.name === name) {
        connectedSocket.emit(SocketEvents.incomingCall, socket.name);
      }
    });
  });
  socket.on(SocketEvents.closeCall, (name) => {
    IO.sockets.sockets.forEach((connectedSocket) => {
      if (connectedSocket?.name === name) {
        connectedSocket.emit(SocketEvents.callClosed);
      }
    });
  });
  socket.on(SocketEvents.acceptCall, (name) => {
    IO.sockets.sockets.forEach((connectedSocket) => {
      if (connectedSocket?.name === name) {
        connectedSocket.emit(SocketEvents.callAccepted, socket.name);
      }
    });
  });
  socket.on('disconnect', (message) => {
    console.log(`AN USER DISCONNECTED ON SOCKET. SOCKET ID is '${socket.id}'. Message is ${message}`);
  });
});

Server.listen(AppConstants.serverPort, () => {
  console.log(`Server started on ${AppConstants.serverPort} port.`);
});
