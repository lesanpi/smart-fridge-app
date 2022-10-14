import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/auth/widgets/open_sign_up_form_button.dart';
import 'package:wifi_led_esp8266/ui/login/login.dart';
import 'package:wifi_led_esp8266/ui/login/widgets/email_input.dart';

/// {@template login_body}
/// Body of the LoginPage.
///
/// Add what it does
/// {@endtemplate}
class LoginBody extends StatelessWidget {
  /// {@macro login_body}
  LoginBody({super.key});

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Consts.defaultPadding,
      ),
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/signin.jpg'),
              const SizedBox(height: Consts.defaultPadding),
              LoginEmailInput(
                focusNode: emailFocusNode,
                nextFocusNode: passwordFocusNode,
              ),
              const SizedBox(height: Consts.defaultPadding / 2),
              LoginPasswordInput(
                focusNode: passwordFocusNode,
              ),
              const SizedBox(height: Consts.defaultPadding / 2),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      letterSpacing: -0.02,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Consts.defaultPadding / 2),
              const LoginButton(),
              const SizedBox(height: Consts.defaultPadding / 2),
              const SignUpButton(),
              const SizedBox(height: Consts.defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
