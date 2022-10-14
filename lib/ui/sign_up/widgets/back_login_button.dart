import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';

class BackLoginButton extends StatelessWidget {
  const BackLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return OutlinedButton(
      onPressed: () => Navigator.pop(context),
      child: Center(
        child: Text(
          'IR A INICIO',
          style: textTheme.bodyLarge?.copyWith(
            color: Consts.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
