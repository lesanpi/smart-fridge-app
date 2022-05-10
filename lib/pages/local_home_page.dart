import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/model/connection_info.dart';
import 'package:wifi_led_esp8266/model/fridge_state.dart';
import 'package:wifi_led_esp8266/pages/fridge_details_page.dart';
import 'package:wifi_led_esp8266/model/fridge.dart';
import 'package:wifi_led_esp8266/repositories/local_repository.dart';
import 'package:wifi_led_esp8266/widgets/button_action.dart';
import 'package:wifi_led_esp8266/widgets/fridge_card.dart';
import 'package:wifi_led_esp8266/widgets/thermostat.dart';

class LocalHomePage extends StatefulWidget {
  const LocalHomePage({Key? key}) : super(key: key);

  @override
  _LocalHomePageState createState() => _LocalHomePageState();
}

class _LocalHomePageState extends State<LocalHomePage> {
  // bool ledstatus = false; //boolean value to track LED status, if its ON or OFF
  // late IOWebSocketChannel channel;
  // bool connected = false; //boolean value to track if WebSocket is connected
  // List<Fridge> fridgeList = [];
  late LocalRepository localRepository =
      RepositoryProvider.of<LocalRepository>(context);

  @override
  void initState() {
    // initWebSocket();
    super.initState();
    localRepository.init();
  }

  @override
  void dispose() {
    super.dispose();
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
        title: StreamBuilder<ConnectionInfo?>(
          stream: localRepository.connectionInfoStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text(
                "Desconectado",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              );
            }

            final ConnectionInfo connectionInfo = snapshot.data!;

            if (connectionInfo == null) {
              return const Text(
                "Desconectado",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              );
            }

            return Text(
              connectionInfo.ssid,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
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
              // height: _screenH * 0.7,
              child: StreamBuilder<bool>(
                stream: localRepository.connectedStream,
                builder: (_, locallyConnectedSnapshot) {
                  if (!locallyConnectedSnapshot.hasData) {
                    return const SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(),
                    );
                  }
                  final locallyConnected = locallyConnectedSnapshot.data!;
                  print(locallyConnected);
                  // return Text(snapshot.data!.toString());
                  return getContent(locallyConnected);
                },
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget getContent(bool connected) {
    if (!connected) {
      return disconnectedMessage();
    }

    return StreamBuilder<ConnectionInfo?>(
      stream: localRepository.connectionInfoStream,
      builder: (_, connectionSnapshot) {
        if (!connectionSnapshot.hasData) {
          return noDataMessage();
        }
        if (connectionSnapshot.data == null) {
          return noDataMessage();
        }

        return StreamBuilder<List<FridgeState>>(
          stream: localRepository.fridgesStateStream,
          builder: (_, fridgesStateSnapshot) {
            final ConnectionInfo connectionInfo = connectionSnapshot.data!;

            if (!fridgesStateSnapshot.hasData) {
              return noDataButConnectedMessage(connectionInfo);
            }

            final List<FridgeState> fridgesState = fridgesStateSnapshot.data!;
            if (connectionInfo.standalone && fridgesState.isNotEmpty) {
              final fridgeState = fridgesState[0];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Thermostat(temperature: fridgeState.temperature),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonAction(
                            onTap: () {},
                            selected: fridgeState.light,
                            iconData: Icons.lightbulb,
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          ButtonAction(
                            onTap: () {},
                            selected: fridgeState.compressor,
                            iconData: Icons.ac_unit_outlined,
                          )
                        ],
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Temperatura mínima",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  fridgeState.minTemperature.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 20,
                                  ),
                                ),
                                Expanded(
                                  child: Slider(
                                    min: -20,
                                    max: 30,
                                    value:
                                        fridgeState.minTemperature.toDouble(),
                                    onChanged: (value) {
                                      print("new value ${value}");
                                    },
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {},
                                  child: Text("Guardar"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Temperatura máxima",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  fridgeState.maxTemperature.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 20,
                                  ),
                                ),
                                Expanded(
                                  child: Slider(
                                    min: -20,
                                    max: 30,
                                    value:
                                        fridgeState.maxTemperature.toDouble(),
                                    onChanged: (value) {
                                      print("new value ${value}");
                                    },
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {},
                                  child: Text("Guardar"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      TextButton(
                        onPressed: () {
                          localRepository.client.disconnect();
                        },
                        child: const Text(
                          "Desconectarse",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return Text("Coordinado");
          },
        );
      },
    );

    // return ListView.builder(
    //   itemCount: localRepository.fridgesId.length,
    //   scrollDirection: Axis.vertical,
    //   // clipBehavior: Clip.none,
    //   itemBuilder: (context, index) {
    //     final Fridge _fridge = Fridge.empty();
    //     return FridgeCard(
    //       fridge: _fridge,
    //       onTap: () {
    //         Navigator.of(context).push(
    //           PageRouteBuilder(
    //             pageBuilder: (_, __, ___) => LocalHomePage(),
    //             transitionDuration: Duration(milliseconds: 500),
    //             transitionsBuilder:
    //                 (context, animation, secondaryAnimation, child) {
    //               const begin = Offset(1.0, 0.0);
    //               const end = Offset.zero;
    //               final tween = Tween(begin: begin, end: end);
    //               final offsetAnimation = animation.drive(tween);
    //               return SlideTransition(
    //                 position: offsetAnimation,
    //                 child: child,
    //               );
    //             },
    //           ),
    //         );
    //       },
    //     );
    //   },
    // );
  }

  Widget disconnectedMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 100,
            color: Colors.black,
          ),
          const SizedBox(height: 30),
          const Text(
            "Desconectado",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w300,
              color: Colors.black38,
            ),
          ),
          TextButton(
            onPressed: () {
              localRepository.connect();
            },
            child: Text("Volver a intentar"),
          )
        ],
      ),
    );
  }

  Widget noDataMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.wifi_off_rounded,
          size: 100,
          color: Colors.black,
        ),
        const SizedBox(height: 30),
        const Text(
          "Sin datos de la conexión",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w300,
            color: Colors.black38,
          ),
        ),
        TextButton(
          onPressed: () {
            localRepository.client.disconnect();
          },
          child: Text("Desconectarse"),
        )
      ],
    );
  }

  Widget noDataButConnectedMessage(ConnectionInfo connectionInfo) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.ac_unit_rounded,
          size: 100,
          color: Colors.black,
        ),
        const SizedBox(height: 30),
        Text(
          connectionInfo.standalone
              ? "Sin datos de la nevera"
              : "No hay neveras",
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w300,
            color: Colors.black38,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Estas conectado a "),
            Text(
              connectionInfo.ssid,
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            )
          ],
        ),
        const SizedBox(height: 5),
        TextButton(
          onPressed: () {
            localRepository.client.disconnect();
          },
          child: const Text("Desconectarse"),
        )
      ],
    );
  }
}
