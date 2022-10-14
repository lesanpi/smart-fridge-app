import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/sign_up/sign_up.dart';
import 'package:wifi_led_esp8266/widgets/input_label.dart';

class SignUpEmailInput extends StatelessWidget {
  const SignUpEmailInput(
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
            const InputLabel(label: 'Correo electrónico'),
            const SizedBox(height: Consts.defaultPadding / 4),
            AutofillGroup(
              child: TextFormField(
                autofocus: true,
                focusNode: focusNode,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Consts.neutral.shade700,
                  ),
                  hintText: 'Ingrese su correo electrónico',
                  errorText: state.email.invalid ? 'Campo obligatorio' : null,
                  // errorText: state.email.invalid ? '' : null,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: context.read<SignUpCubit>().emailChanged,
                autofillHints: const [AutofillHints.email],
                inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                onFieldSubmitted: (value) {
                  nextFocusNode.requestFocus();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
