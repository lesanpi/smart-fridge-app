import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:wifi_led_esp8266/ui/forget_password/forget_password.dart';
import 'package:wifi_led_esp8266/widgets/loading_button.dart';

class VerifyCodeButton extends StatelessWidget {
  const VerifyCodeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
      builder: (context, state) {
        final loading = state.status.isSubmissionInProgress;
        return ElevatedButton(
          onPressed: loading
              ? null
              : () => context.read<ForgetPasswordCubit>().verifyCode(),
          // onPressed: _onSignInPressed(context),
          child: Center(
            child: loading
                ? const LoadingButton()
                : Text(
                    "VERIFICAR",
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
