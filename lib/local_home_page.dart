import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:wifi_led_esp8266/fridge_card.dart';
import 'package:wifi_led_esp8266/fridge_details_page.dart';
import 'package:wifi_led_esp8266/model/fridge.dart';

class LocalHomePage extends StatefulWidget {
  const LocalHomePage({Key? key}) : super(key: key);

  @override
  _LocalHomePageState createState() => _LocalHomePageState();
}

class _LocalHomePageState extends State<LocalHomePage> {
  bool ledstatus = false; //boolean value to track LED status, if its ON or OFF
  late IOWebSocketChannel channel;
  bool connected = false; //boolean value to track if WebSocket is connected
  List<Fridge> fridgeList = [];

  @override
  void initState() {
    initWebSocket();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            dynamic idsRegistered = data["id_registered"];
            print("idsRegistered");
            print(idsRegistered);
            print(idsRegistered.runtimeType);

            List<Fridge> _fridgeListDecoded = [];
            if (idsRegistered != null) {
              idsRegistered.forEach((id) {
                if (id is String && id != null) {
                  print("Id $id");
                  // print("Temp ${data["devices"]}")
                  _fridgeListDecoded.add(
                    Fridge(
                      id: data["devices"][id]["id"],
                      temperature: data["devices"][id]["temp"],
                    ),
                  );
                }
              });
            }

            setState(() {
              fridgeList = _fridgeListDecoded;
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

  void initWebSocket() {
    ledstatus = false; //initially leadstatus is off so its FALSE
    connected = false; //initially connection status is "NO" so its FALSE
    Future.delayed(Duration.zero, () async {
      channelconnect(); //connect to WebSocket wth NodeMCU
    });
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
    final double _screenW = MediaQuery.of(context).size.width;
    final double _screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Transform.scale(
          scale: 0.8,
          child: Hero(
            tag: "logo_hero",
            child: Image.asset(
              'assets/images/icon.png',
              width: 50,
              height: 50,
            ),
          ),
        ),
        centerTitle: true,
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
          child: LayoutBuilder(builder: (context, constraints) {
            final h = constraints.maxHeight;
            final w = constraints.maxWidth;

            return Container(
              color: Colors.white,
              width: w,
              height: _screenH * 0.7,
              child: fridgeList.length > 0
                  ? ListView.builder(
                      itemCount: fridgeList.length,
                      scrollDirection: Axis.vertical,
                      // clipBehavior: Clip.none,
                      itemBuilder: (context, index) {
                        final Fridge _fridge = fridgeList[index];
                        return FridgeCard(
                          fridge: _fridge,
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => FridgeDetailsPage(
                                  fridge: _fridge,
                                ),
                                transitionDuration: Duration(milliseconds: 500),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  final tween = Tween(begin: begin, end: end);
                                  final offsetAnimation =
                                      animation.drive(tween);
                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: FridgeDetailsPage(
                                      fridge: _fridge,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        "No hay neveras",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: Colors.black38,
                        ),
                      ),
                    ),
            );
          }),
        ),
      ),
    );
  }
}
