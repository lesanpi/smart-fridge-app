import 'dart:convert';

import 'package:web_socket_channel/io.dart';

class LocalWebSocketApi {
  late IOWebSocketChannel channel;

  void init() {
    Future.delayed(Duration(milliseconds: 300), () async {
      connectChannel();
    });
  }

  void connectChannel() {
    //function to connect
    try {
      channel = IOWebSocketChannel.connect("ws://192.168.0.1:81");
      //channel IP : Port
      channel.stream.listen(
        (message) {
          if (message == "connected") {
            // TODO: Connected
          } else if (message == "poweron:success") {
            // TODO: Turn on Led.
          } else if (message == "poweroff:success") {
            // TODO: Turn off led.
          } else {
            final data = json.decode(message);
          }
        },
        onDone: () {
          //if WebSocket is disconnected
          // channelDisconnected();
          disconnectChannel();
        },
        onError: (error) {
          disconnectChannel();
          //print(error.toString());
        },
      );
    } catch (_) {
      //print("error on connecting to websocket.");
    }
  }

  void disconnectChannel() {
    channel.sink.close();
  }
}
