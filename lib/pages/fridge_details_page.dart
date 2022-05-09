import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:wifi_led_esp8266/bloc/local_bloc.dart';
import 'package:wifi_led_esp8266/model/fridge.dart';
import 'package:wifi_led_esp8266/utils/utils.dart';
import 'package:wifi_led_esp8266/widgets/thermostat.dart';
import 'package:wifi_led_esp8266/widgets/button_action.dart';
import 'package:wifi_led_esp8266/widgets/connection_status.dart';

class FridgeDetailsPage extends StatefulWidget {
  final Fridge fridge;
  final LocalBLoC bloc;
  const FridgeDetailsPage({Key? key, required this.bloc, required this.fridge})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FridgeDetailsPage();
  }
}

class _FridgeDetailsPage extends State<FridgeDetailsPage> {
  int temperature = 404;

  @override
  void initState() {
    temperature = widget.fridge.temperature;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return ValueListenableBuilder<Fridge>(
        valueListenable: bloc.localFridgeSelected,
        builder: (context, _fridge, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                "Nevera #1 - Casa Luis",
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w500),
              ),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  //print('Back Button');
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  CupertinoIcons.back,
                  color: Colors.black87,
                ),
              ),
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
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (details.primaryDelta! > 9) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    height: h,
                    color: Colors.white,
                    alignment: Alignment.topCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConnectionStatus(
                          connected: bloc.localConnected.value,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Thermostat(temperature: _fridge.temperature),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonAction(
                              onTap: () {},
                              selected: true,
                              iconData: Icons.lightbulb,
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            ButtonAction(
                              onTap: () {},
                              selected: false,
                              iconData: Icons.ac_unit_outlined,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
