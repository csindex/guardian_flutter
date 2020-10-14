import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {

  IO.Socket socket;

  createSocketConnection() {
    socket = IO.io('https://dep.guardian4emergency.com:2020', <String, dynamic>{
      'transports': ['websocket'],
    });

    this.socket.on("connect", (_) => print('Connected'));
    this.socket.on("disconnect", (_) => print('Disconnected'));
  }

}