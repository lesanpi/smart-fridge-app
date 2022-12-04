import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/forget_password/forget_password.dart';
import 'package:wifi_led_esp8266/widgets/input_label.dart';

class ForgetPasswordConfirmPasswordInput extends StatelessWidget {
  const ForgetPasswordConfirmPasswordInput(
      {super.key, required this.focusNode});
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InputLabel(label: 'Confirmar contraseña'),
            const SizedBox(height: Consts.defaultPadding / 4),
            AutofillGroup(
              child: TextFormField(
                focusNode: focusNode,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Consts.neutral.shade700,
                  ),
                  hintText: 'Confirme su contraseña',
                  errorText: !(state.newPassword.value ==
                              state.newPasswordConfirm.value) &&
                          !state.newPassword.pure
                      ? 'Las contraseñas no coinciden.'
                      : null,
                  // errorText: state.email.invalid ? '' : null,
                ),
                onChanged:
                    context.read<ForgetPasswordCubit>().passwordConfirmChanged,
                autofillHints: const [AutofillHints.password],
              ),
            ),
          ],
        );
      },
    );
  }
}
