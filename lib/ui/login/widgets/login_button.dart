import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:wifi_led_esp8266/ui/login/login.dart';
import 'package:wifi_led_esp8266/widgets/loading_button.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final loading = state.status.isSubmissionInProgress;
        return ElevatedButton(
          onPressed: loading
              ? null
              : () => context.read<LoginCubit>().loginButtonPressed(),
          // onPressed: _onSignInPressed(context),
          child: Center(
            child: loading
                ? const LoadingButton()
                : Text(
                    "INGRESAR",
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
