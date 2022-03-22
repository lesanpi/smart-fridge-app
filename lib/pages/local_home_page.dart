import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:wifi_led_esp8266/bloc/app_bloc.dart';
import 'package:wifi_led_esp8266/pages/fridge_details_page.dart';
import 'package:wifi_led_esp8266/model/fridge.dart';
import 'package:wifi_led_esp8266/widgets/fridge_card.dart';

class LocalHomePage extends StatefulWidget {
  const LocalHomePage({Key? key}) : super(key: key);

  @override
  _LocalHomePageState createState() => _LocalHomePageState();
}

class _LocalHomePageState extends State<LocalHomePage> {
  final bloc = AppBLoC();

  // bool ledstatus = false; //boolean value to track LED status, if its ON or OFF
  // late IOWebSocketChannel channel;
  // bool connected = false; //boolean value to track if WebSocket is connected
  // List<Fridge> fridgeList = [];

  @override
  void initState() {
    // initWebSocket();
    bloc.init();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenW = MediaQuery.of(context).size.width;
    final double _screenH = MediaQuery.of(context).size.height;

    return AppProvider(
      bloc: bloc,
      child: Scaffold(
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
                bloc.init();
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
                  child: ValueListenableBuilder<List<Fridge>>(
                    valueListenable: bloc.localFridgeList,
                    builder: (context, fridgeList, _) {
                      if (fridgeList.length > 0) {
                        return ListView.builder(
                          itemCount: fridgeList.length,
                          scrollDirection: Axis.vertical,
                          // clipBehavior: Clip.none,
                          itemBuilder: (context, index) {
                            final Fridge _fridge = fridgeList[index];
                            return FridgeCard(
                              fridge: _fridge,
                              onTap: () {
                                bloc.setLocalFridgeSelectedIndex(_fridge);
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        FridgeDetailsPage(
                                      bloc: bloc,
                                      fridge: _fridge,
                                    ),
                                    transitionDuration:
                                        Duration(milliseconds: 500),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      final tween =
                                          Tween(begin: begin, end: end);
                                      final offsetAnimation =
                                          animation.drive(tween);
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
                      } else {
                        return const Center(
                          child: Text(
                            "No hay neveras",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              color: Colors.black38,
                            ),
                          ),
                        );
                      }
                    },
                  ));
            }),
          ),
        ),
      ),
    );
  }
}
