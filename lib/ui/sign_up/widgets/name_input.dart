import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/sign_up/sign_up.dart';
import 'package:wifi_led_esp8266/widgets/input_label.dart';

class SignUpNameInput extends StatelessWidget {
  const SignUpNameInput(
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
            const InputLabel(label: 'Nombre completo'),
            const SizedBox(height: Consts.defaultPadding / 4),
            AutofillGroup(
              child: TextFormField(
                focusNode: focusNode,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Consts.neutral.shade700,
                  ),
                  hintText: 'Ingrese su nombre completo',
                  errorText: state.name.invalid ? 'Campo obligatorio' : null,

                  // errorText: state.email.invalid ? '' : null,
                ),
                keyboardType: TextInputType.name,
                onChanged: context.read<SignUpCubit>().nameChanged,
                autofillHints: const [AutofillHints.name],
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
