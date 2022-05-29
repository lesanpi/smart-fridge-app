import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/auth/cubit/auth_cubit.dart';

class BackToSignInButton extends StatelessWidget {
  const BackToSignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '¿Ya tienes una cuenta?',
            style: textTheme.bodyMedium?.copyWith(
              color: Consts.lightSystem.shade100,
            ),
          ),
          TextButton(
            onPressed: () => context.read<AuthCubit>().goTo(AuthState.SIGNIN),
            child: Text('Inicia sesión'),
            style: TextButton.styleFrom(
              primary: Consts.primary,
              textStyle: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
