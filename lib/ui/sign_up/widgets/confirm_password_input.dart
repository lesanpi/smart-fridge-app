import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/sign_up/sign_up.dart';
import 'package:wifi_led_esp8266/widgets/input_label.dart';

class SignUpConfirmPasswordInput extends StatelessWidget {
  const SignUpConfirmPasswordInput({super.key, required this.focusNode});
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
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
                  errorText: !state.samePassword && !state.password.pure
                      ? 'Las contraseñas no coinciden.'
                      : null,
                  // errorText: state.email.invalid ? '' : null,
                ),
                onChanged: context.read<SignUpCubit>().confirmPasswordChanged,
                autofillHints: const [AutofillHints.password],
              ),
            ),
          ],
        );
      },
    );
  }
}
