import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/theme.dart';

class ExitButton extends StatelessWidget {
  const ExitButton({Key? key, this.onTap}) : super(key: key);
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // final outlinedButtonStyle = Theme.of(context).outlinedButtonTheme.style;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: Consts.error,
        side: const BorderSide(
          color: Consts.error,
          width: 1.0,
        ),
        shape: CustomTheme.buttonShape,
      ),
      onPressed: () async {
        Navigator.pop(context);

        if (onTap != null) {
          onTap!();
        }
      },
      child: const Text("SALIR"),
    );
  }
}
