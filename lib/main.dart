import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/io.dart';
import 'package:wifi_led_esp8266/connection_status.dart';
import 'package:wifi_led_esp8266/thermostat.dart';
import 'utils.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

void setSystemUI() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setSystemUI();

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        buttonTheme: ButtonThemeData(
          buttonColor: primaryColor,
          shape: RoundedRectangleBorder(),
          textTheme: ButtonTextTheme.accent,
        ),
      ),
      home: WebSocketLed(),
    );
  }
}

//apply this class on home: attribute at MaterialApp()
class WebSocketLed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebSocketLed();
  }
}

class _WebSocketLed extends State<WebSocketLed> {
  bool ledstatus = false; //boolean value to track LED status, if its ON or OFF
  late IOWebSocketChannel channel;
  bool connected = false; //boolean value to track if WebSocket is connected
  int temperature = 404;

  @override
  void initState() {
    ledstatus = false; //initially leadstatus is off so its FALSE
    connected = false; //initially connection status is "NO" so its FALSE
    temperature = 404;
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
          setState(() {
            if (message == "connected") {
              connected = true; //message is "connected" from NodeMCU
            } else if (message == "poweron:success") {
              ledstatus = true;
            } else if (message == "poweroff:success") {
              ledstatus = false;
            } else {
              final data = json.decode(message);
              print(data["temp"]);
              setState(() {
                temperature = data["temp"];
              });
            }
          });
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
