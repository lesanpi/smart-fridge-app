import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/forget_password/forget_password.dart';

import 'package:wifi_led_esp8266/widgets/input_label.dart';

class ForgetPassordEmailInput extends StatelessWidget {
  const ForgetPassordEmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InputLabel(label: 'Correo electrónico'),
            const SizedBox(height: Consts.defaultPadding / 4),
            AutofillGroup(
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Consts.neutral.shade700,
                  ),
                  hintText: 'Ingrese su correo electrónico',
                  errorText: state.email.pure ? null : state.email.errorMessage,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: context.read<ForgetPasswordCubit>().emailChanged,
                autofillHints: const [AutofillHints.email],
                inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                onFieldSubmitted: (_) {
                  context.read<ForgetPasswordCubit>().emailSubmitted();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
