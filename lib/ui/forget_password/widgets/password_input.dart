import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/forget_password/forget_password.dart';
import 'package:wifi_led_esp8266/widgets/input_label.dart';

class ForgetPasswordPasswordInput extends StatelessWidget {
  const ForgetPasswordPasswordInput(
      {super.key, required this.focusNode, required this.nextFocusNode});
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
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
                    errorText: state.newPassword.invalid
                        ? 'Contraseña inválida. Debe contener al menos 8 caracteres, uno numérico, una letra mayúscula y una minúscula y un carácter especial.'
                        : null,
                    errorMaxLines: 3

                    // errorText: state.email.invalid ? '' : null,
                    ),
                onChanged: context.read<ForgetPasswordCubit>().passwordChanged,
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
