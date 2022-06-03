import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/connection_info.dart';
import 'package:wifi_led_esp8266/ui/local/local.dart';

class SetupAppBar extends StatelessWidget {
  const SetupAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Consts.lightSystem.shade300,
      // backgroundColor: Consts.neutral.shade300,
      leading: BackButton(color: Consts.neutral.shade700),
      centerTitle: true,
      title: Text(
        'Agregar nuevo dispositivo',
        style: TextStyle(
          color: Consts.neutral.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
