import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket socket;

  createSocketConnection() {
    print('socket create');
    socket = IO.io('http://dev.guardian.ph:5000', <String, dynamic> {
      'transports': ['websocket'],
      'upgrade': false,
    });
    socket.connect();
    socket.onConnect((_) {
      print('socket connect');
      // socket.emit('msg', 'test');
    });
    socket.onError((data) => print('socket error - $data'));
    socket.onDisconnect((_) => print('socket disconnect'));
  }

  // createSocketConnection() {
  //   print('socket create');
  //   socket = IO.io('http://10.128.50.112:5000');
  //   socket.onConnect((_) {
  //     print('socket connect');
  //     // socket.emit('msg', 'test');
  //   });
  //   socket.onError((data) => print('socket error - $data'));
  //   socket.onDisconnect((_) => print('socket disconnect'));
  // }

  clearSocket() {
    socket.disconnect();
    socket.destroy();
    socket = null;
    print('socket destroyed');
  }

}
