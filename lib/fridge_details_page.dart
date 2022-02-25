import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:wifi_led_esp8266/connection_status.dart';
import 'package:wifi_led_esp8266/model/fridge.dart';
import 'package:wifi_led_esp8266/thermostat.dart';

class FridgeDetailsPage extends StatefulWidget {
  final Fridge fridge;

  const FridgeDetailsPage({Key? key, required this.fridge}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FridgeDetailsPage();
  }
}

class _FridgeDetailsPage extends State<FridgeDetailsPage> {
  bool ledstatus = false; //boolean value to track LED status, if its ON or OFF
  late IOWebSocketChannel channel;
  bool connected = false; //boolean value to track if WebSocket is connected
  int temperature = 404;

  @override
  void initState() {
    ledstatus = false; //initially leadstatus is off so its FALSE
    connected = false; //initially connection status is "NO" so its FALSE
    temperature = widget.fridge.temperature;
    Future.delayed(Duration.zero, () async {
      channelconnect(); //connect to WebSocket wth NodeMCU
    });

    super.initState();
  }

  void channelconnect() {
    //function to connect
    try {
      channel =
          IOWebSocketChannel.connect("ws://192.168.0.1:81"); //channel IP : Port
      channel.stream.listen(
        (message) {
          print("Message received $message");
          print("Message type ${message.runtimeType}");
          if (message == "connected") {
            setState(() {
              connected = true; //message is "connected" from NodeMCU
            });
          } else if (message == "poweron:success") {
            ledstatus = true;
          } else if (message == "poweroff:success") {
            ledstatus = false;
          } else {
            final data = json.decode(message);
            print("Temp ${data["temp"]}");

            setState(() {
              temperature = data["devices"][widget.fridge.id]["temp"];
            });
          }
        },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (_) {
      print("error on connecting to websocket.");
    }
  }

  Future<void> sendcmd(String cmd) async {
    if (connected == true) {
      if (ledstatus == false &&
          cmd != "poweron" &&
          cmd != "poweroff" &&
          cmd != "temperature") {
        print("Send the valid command");
      } else {
        channel.sink.add(cmd); //sending Command to NodeMCU
      }
    } else {
      channelconnect();
      print("Websocket is not connected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Nevera #1 - Casa Luis",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            print('Back Button');
            Navigator.of(context).pop();
          },
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (!connected)
                channelconnect();
              else
                sendcmd("temperature");
            },
            icon: const Icon(
              CupertinoIcons.refresh,
              color: Colors.black87,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: Container(
            alignment: Alignment.topCenter, //inner widget alignment to center
            // padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConnectionStatus(
                  connected: connected,
                ),
                SizedBox(
                  height: 20,
                ),
                Thermostat(temperature: temperature)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
