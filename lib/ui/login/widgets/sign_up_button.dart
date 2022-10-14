import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/sign_up/sign_up.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return OutlinedButton(
      onPressed: () => Navigator.push(context, SignUpPage.route()),
      child: Center(
        child: Text(
          'REGISTRARSE',
          style: textTheme.bodyLarge?.copyWith(
            color: Consts.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
