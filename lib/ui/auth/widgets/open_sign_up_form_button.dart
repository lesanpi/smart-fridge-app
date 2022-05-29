import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/auth/cubit/auth_cubit.dart';

class OpenSignUpFormButton extends StatelessWidget {
  const OpenSignUpFormButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return OutlinedButton(
      onPressed: () => context.read<AuthCubit>().goTo(AuthState.SIGNUP),
      child: Text(
        'REGISTRARSE',
        style: textTheme.bodyLarge?.copyWith(
          color: Consts.primary.shade400,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
