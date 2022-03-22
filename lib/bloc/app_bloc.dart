import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:wifi_led_esp8266/model/fridge.dart';

class AppBLoC {
  final localFridgeList = ValueNotifier<List<Fridge>>([]);
  final localIdsRegistered = ValueNotifier<List<String>>([]);
  final localFridgeSelected = ValueNotifier<Fridge>(Fridge.empty());
  final localConnected = ValueNotifier<bool>(false);
  late IOWebSocketChannel channel;

  void init() {
    localFridgeList.value = [];
    localIdsRegistered.value = [];
    localFridgeSelected.value = Fridge.empty();
    localConnected.value = false;
    initWebSocket();
  }

  void dispose() {}

  void initWebSocket() {
    Future.delayed(Duration.zero, () async {
      //connect to WebSocket wth NodeMCU
      channelconnect();
    });
  }

  void channelconnect() {
    //function to connect
    try {
      channel = IOWebSocketChannel.connect("ws://192.168.0.1:81");
      //channel IP : Port
      channel.stream.listen(
        (message) {
          if (message == "connected") {
            localConnected.value = true; //message is "connected" from NodeMCU

          } else if (message == "poweron:success") {
            // TODO: Turn on Led.
          } else if (message == "poweroff:success") {
            // TODO: Turn off led.
          } else {
            final data = json.decode(message);

            List<Fridge> _fridgeListDecoded = [];
            List<String> _fridgeIdsDecoded = [];
            final _idsRegisteredReceived = data["id_registered"];
            if (_idsRegisteredReceived != null) {
              _idsRegisteredReceived.forEach((id) {
                if (id is String && id != null) {
                  //print("Id $id");
                  _fridgeIdsDecoded.add(id);
                  _fridgeListDecoded.add(
                    Fridge(
                      id: data["devices"][id]["id"],
                      temperature: data["devices"][id]["temp"],
                    ),
                  );
                }
              });
            }

            localIdsRegistered.value = _fridgeIdsDecoded;
            localFridgeList.value = _fridgeListDecoded;
          }
        },
        onDone: () {
          //if WebSocket is disconnected
          //print("Web socket is closed");
          channelDisconnected();
        },
        onError: (error) {
          channelDisconnected();
          //print(error.toString());
        },
      );
    } catch (_) {
      //print("error on connecting to websocket.");
    }
  }

  void channelDisconnected() {
    localConnected.value = false;
    localFridgeList.value = [];
    localIdsRegistered.value = [];
  }

  Future<void> sendcmd(String cmd) async {
    if (localConnected.value == true) {
      channel.sink.add(cmd);
    } else {
      channelconnect();
      //print("Websocket is not connected.");
    }
  }

  void setLocalFridgeSelectedIndex(Fridge fridge) {
    localFridgeSelected.value = fridge;
  }
}

class AppProvider extends InheritedWidget {
  final AppBLoC bloc;

  AppProvider({required this.bloc, required Widget child})
      : super(child: child);

  static AppProvider? of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<AppProvider>();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
