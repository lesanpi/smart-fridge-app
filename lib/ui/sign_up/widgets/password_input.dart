import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/sign_up/sign_up.dart';
import 'package:wifi_led_esp8266/widgets/input_label.dart';

class SignUpPasswordInput extends StatelessWidget {
  const SignUpPasswordInput(
      {super.key, required this.focusNode, required this.nextFocusNode});
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InputLabel(label: 'Contraseña'),
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
                  hintText: 'Ingrese su contraseña',
                  errorText: state.password.invalid
                      ? 'Contraseña inválida. Debe contener al menos 8 caracteres, uno numérico, una letra mayúscula y una minúscula y un carácter especial.'
                      : null,

                  // errorText: state.email.invalid ? '' : null,
                ),
                onChanged: context.read<SignUpCubit>().passwordChanged,
                onFieldSubmitted: (value) {
                  nextFocusNode.requestFocus();
                },
                autofillHints: const [AutofillHints.password],
              ),
            ),
          ],
        );
      },
    );
  }
}
