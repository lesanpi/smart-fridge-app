import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/forget_password/cubit/cubit.dart';
import 'package:wifi_led_esp8266/ui/forget_password/widgets/back_step_button.dart';
import 'package:wifi_led_esp8266/ui/forget_password/widgets/change_password_button.dart';
import 'package:wifi_led_esp8266/ui/forget_password/widgets/confirm_password_input.dart';
import 'package:wifi_led_esp8266/ui/forget_password/widgets/email_input.dart';
import 'package:wifi_led_esp8266/ui/forget_password/widgets/password_input.dart';
import 'package:wifi_led_esp8266/ui/forget_password/widgets/send_email_button.dart';
import 'package:wifi_led_esp8266/ui/forget_password/widgets/verify_code_button.dart';
import 'package:wifi_led_esp8266/widgets/floating_widget.dart';

import 'code_input.dart';

/// {@template forget_password_body}
/// Body of the ForgetPasswordPage.
///
/// Add what it does
/// {@endtemplate}
class ForgetPasswordBody extends StatelessWidget {
  /// {@macro forget_password_body}
  ForgetPasswordBody({super.key});
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Consts.defaultPadding,
      ),
      child: BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
        builder: (context, state) {
          // return Text('${state.step}');
          if (state.step == ForgetPasswordStep.email) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  FloatingWidget(child: Image.asset('assets/images/error.jpg')),
                  const ForgetPassordEmailInput(),
                  const SizedBox(height: Consts.defaultPadding),
                  const SendEmailButton(),
                  const SizedBox(height: Consts.defaultPadding),
                ],
              ),
            );
          }
          if (state.step == ForgetPasswordStep.newPassword) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/signup.jpg',
                  ),
                  Text(
                    'Nueva contraseña',
                    style: textTheme.headline5?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: Consts.defaultPadding / 2),
                  Text(
                    'Ingresa tu nueva contraseña',
                    style: textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: Consts.defaultPadding),
                  ForgetPasswordPasswordInput(
                    focusNode: passwordFocusNode,
                    nextFocusNode: confirmPasswordFocusNode,
                  ),
                  const SizedBox(height: Consts.defaultPadding / 2),
                  ForgetPasswordConfirmPasswordInput(
                    focusNode: confirmPasswordFocusNode,
                  ),
                  const SizedBox(height: Consts.defaultPadding),
                  const ChangePasswordButton(),
                  const SizedBox(height: Consts.defaultPadding / 2),
                ],
              ),
            );
          }

          if (state.step == ForgetPasswordStep.code) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FloatingWidget(
                      child: Image.asset(
                        'assets/images/signin.jpg',
                      ),
                    ),
                    Text(
                      'Verificación',
                      style: textTheme.headline5?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: Consts.defaultPadding / 2),
                    Text(
                      'Ingresa el código enviado a tu correo electrónico',
                      style: textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: Consts.defaultPadding),
                    const ForgetPasswordCodeInput(),
                    const SizedBox(height: Consts.defaultPadding),
                    const VerifyCodeButton(),
                    const SizedBox(height: Consts.defaultPadding / 2),
                    const BackStepButton(),
                  ],
                ),
              ),
            );
          }

          return Center(child: Text(state.customProperty));
        },
      ),
    );
  }
}
