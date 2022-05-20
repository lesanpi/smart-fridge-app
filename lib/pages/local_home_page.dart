import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/model/connection_info.dart';
import 'package:wifi_led_esp8266/model/fridge_state.dart';
import 'package:wifi_led_esp8266/pages/fridge_details_page.dart';
import 'package:wifi_led_esp8266/model/fridge.dart';
import 'package:wifi_led_esp8266/repositories/local_repository.dart';
import 'package:wifi_led_esp8266/widgets/button_action.dart';
import 'package:wifi_led_esp8266/widgets/fridge_card.dart';
import 'package:wifi_led_esp8266/widgets/thermostat.dart';
import 'package:wifi_led_esp8266/widgets/fridge_widget.dart';

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
  late final double _screenW = MediaQuery.of(context).size.width;
  late final double _screenH = MediaQuery.of(context).size.height;

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: StreamBuilder<ConnectionInfo?>(
            stream: localRepository.connectionInfoStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text(
                  "Desconectado",
                  style: TextStyle(
                    color: Consts.primary,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }

              final ConnectionInfo connectionInfo = snapshot.data!;

              if (connectionInfo == null) {
                return const Text(
                  "Desconectado",
                  style: TextStyle(
                    color: Consts.primary,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }

              return Text(
                connectionInfo.ssid,
                style: const TextStyle(
                  color: Consts.primary,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        centerTitle: true,
        actions: [],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(),
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
                    return disconnectedMessage();
                  }
                  final locallyConnected = locallyConnectedSnapshot.data!;
                  print(locallyConnected);
                  // return Text(snapshot.data!.toString());
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: getContent(locallyConnected),
                  );
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

        return AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: StreamBuilder<List<FridgeState>>(
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
                      child: FridgeWidget(fridgeState: fridgeState)),
                );
              }

              return Text("Coordinado");
            },
          ),
        );
      },
    );
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
          Text("Verifica si estas conectado correctamente"),
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
              style:
                  TextStyle(color: Consts.primary, fontWeight: FontWeight.bold),
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
