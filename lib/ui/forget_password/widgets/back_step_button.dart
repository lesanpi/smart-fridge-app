import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/forget_password/forget_password.dart';

class BackStepButton extends StatelessWidget {
  const BackStepButton({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
      builder: (context, state) {
        final loading = state.status.isSubmissionInProgress;
        return OutlinedButton(
          onPressed: loading
              ? null
              : () => {context.read<ForgetPasswordCubit>().backButtonPressed()},
          // onPressed: _onSignInPressed(context),
          child: Center(
            child: Text(
              "REGRESAR",
              style: textTheme.bodyLarge?.copyWith(
                color: Consts.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      },
    );
  }
}
