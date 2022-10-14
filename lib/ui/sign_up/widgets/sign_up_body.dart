import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/sign_up/sign_up.dart';
import 'package:wifi_led_esp8266/ui/sign_up/widgets/confirm_password_input.dart';
import 'package:wifi_led_esp8266/widgets/custom_back_button.dart';

/// {@template sign_up_body}
/// Body of the SignUpPage.
///
/// Add what it does
/// {@endtemplate}
class SignUpBody extends StatelessWidget {
  /// {@macro sign_up_body}
  SignUpBody({super.key});

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: Consts.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/signup.jpg'),
              Text(
                'Nuevo usuario',
                style: textTheme.headline5?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Consts.primary,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: Consts.defaultPadding / 2),
              SignUpEmailInput(
                  focusNode: emailFocusNode, nextFocusNode: nameFocusNode),
              const SizedBox(height: Consts.defaultPadding / 2),
              SignUpNameInput(
                  focusNode: nameFocusNode, nextFocusNode: passwordFocusNode),
              const SizedBox(height: Consts.defaultPadding / 2),
              // TODO: phone input
              SignUpPasswordInput(
                focusNode: passwordFocusNode,
                nextFocusNode: confirmPasswordFocusNode,
              ),
              const SizedBox(height: Consts.defaultPadding / 2),
              SignUpConfirmPasswordInput(focusNode: confirmPasswordFocusNode),
              const SizedBox(height: Consts.defaultPadding),
              const SignUpButton(),
              const SizedBox(height: Consts.defaultPadding / 2),
              const BackLoginButton(),
              const SizedBox(height: Consts.defaultPadding),
            ],
          ),
        ),
        const Positioned(
          child: CustomBackButton(),
          left: Consts.defaultPadding,
          // top: 0,
          // height: 40,
          // width: 50,
        ),
      ],
    );
  }
}
