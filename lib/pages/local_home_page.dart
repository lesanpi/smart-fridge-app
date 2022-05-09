import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/pages/fridge_details_page.dart';
import 'package:wifi_led_esp8266/model/fridge.dart';
import 'package:wifi_led_esp8266/repositories/local_repository.dart';
import 'package:wifi_led_esp8266/widgets/fridge_card.dart';

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
              height: _screenH * 0.7,
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
              "Disconnected",
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

    if (localRepository.fridgesId.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.ac_unit_rounded,
              size: 100,
              color: Colors.black,
            ),
            const SizedBox(height: 30),
            const Text(
              "No hay neveras",
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
        ),
      );
    }

    return ListView.builder(
      itemCount: localRepository.fridgesId.length,
      scrollDirection: Axis.vertical,
      // clipBehavior: Clip.none,
      itemBuilder: (context, index) {
        final Fridge _fridge = Fridge.empty();
        return FridgeCard(
          fridge: _fridge,
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => LocalHomePage(),
                transitionDuration: Duration(milliseconds: 500),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  final tween = Tween(begin: begin, end: end);
                  final offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
