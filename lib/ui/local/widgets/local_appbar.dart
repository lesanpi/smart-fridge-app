import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/connection_info.dart';
import 'package:wifi_led_esp8266/ui/local/local.dart';

class LocalAppBar extends StatelessWidget {
  const LocalAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Consts.lightSystem.shade300,
      leading: BackButton(color: Consts.neutral.shade700),
      centerTitle: true,
      title: BlocBuilder<ConnectionCubit, ConnectionInfo?>(
        builder: (context, connectionInfo) {
          return Text(
            connectionInfo != null ? "Conectado" : "Desconectado",
            style: TextStyle(
              color: Consts.neutral.shade700,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }
}
