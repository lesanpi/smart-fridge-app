import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:wifi_led_esp8266/ui/sign_up/sign_up.dart';
import 'package:wifi_led_esp8266/widgets/loading_button.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        final loading = state.status.isSubmissionInProgress;

        return ElevatedButton(
          onPressed:
              loading ? null : () => context.read<SignUpCubit>().signUp(),
          // onPressed: _onSignInPressed(context),
          child: Center(
            child: loading
                ? const LoadingButton()
                : Text(
                    "REGISTRAR",
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
