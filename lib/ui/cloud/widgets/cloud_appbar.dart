import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/connection_info.dart';
import 'package:wifi_led_esp8266/ui/local/bloc/connection_bloc.dart';
import 'package:wifi_led_esp8266/ui/local/local.dart';

class CloudAppBar extends StatelessWidget {
  const CloudAppBar({Key? key, this.onBack}) : super(key: key);
  final VoidCallback? onBack;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Consts.lightSystem.shade300,
      leading: BackButton(
        color: Consts.neutral.shade700,
        onPressed: () {
          if (onBack != null) {
            onBack!();
          }
          Navigator.maybePop(context);
        },
      ),
      centerTitle: true,
      title: Text(
        "Neveras Remotas",
        style: TextStyle(
          color: Consts.neutral.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
