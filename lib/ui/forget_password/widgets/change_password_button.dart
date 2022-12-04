import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:wifi_led_esp8266/ui/forget_password/forget_password.dart';
import 'package:wifi_led_esp8266/widgets/loading_button.dart';

class ChangePasswordButton extends StatelessWidget {
  const ChangePasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
      builder: (context, state) {
        final loading = state.status.isSubmissionInProgress;
        return ElevatedButton(
          onPressed: loading ||
                  state.newPassword.pure ||
                  state.newPasswordConfirm.pure ||
                  state.newPassword.invalid ||
                  state.newPassword.value != state.newPasswordConfirm.value
              ? null
              : () =>
                  context.read<ForgetPasswordCubit>().changePasswordPressed(),
          // onPressed: _onSignInPressed(context),
          child: Center(
            child: loading
                ? const LoadingButton()
                : Text(
                    "CAMBIAR CONTRASEÑA",
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
