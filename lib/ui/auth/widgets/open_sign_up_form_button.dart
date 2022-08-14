import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/auth/cubit/auth_cubit.dart';
import 'package:wifi_led_esp8266/ui/auth/view/sign_up_page.dart';

class OpenSignUpFormButton extends StatelessWidget {
  const OpenSignUpFormButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return OutlinedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignUpPage()),
      ),
      child: Text(
        'REGISTRARSE',
        style: textTheme.bodyLarge?.copyWith(
          color: Consts.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
