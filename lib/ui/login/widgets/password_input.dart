import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/login/login.dart';
import 'package:wifi_led_esp8266/widgets/input_label.dart';

class LoginPasswordInput extends StatelessWidget {
  const LoginPasswordInput({super.key, required this.focusNode});
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
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
                  // errorText: state.email.invalid ? '' : null,
                ),
                onChanged: context.read<LoginCubit>().passwordChanged,
                autofillHints: const [AutofillHints.password],
              ),
            ),
          ],
        );
      },
    );
  }
}
