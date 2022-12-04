import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:wifi_led_esp8266/ui/forget_password/cubit/cubit.dart';
import 'package:wifi_led_esp8266/ui/forget_password/widgets/forget_password_body.dart';
import 'package:wifi_led_esp8266/ui/home/widgets/notification_snackbar.dart';
import 'package:wifi_led_esp8266/ui/login/login.dart';

import 'package:wifi_led_esp8266/widgets/custom_back_button.dart';

/// {@template forget_password_page}
/// A description for ForgetPasswordPage
/// {@endtemplate}
class ForgetPasswordPage extends StatelessWidget {
  /// {@macro forget_password_page}
  const ForgetPasswordPage({super.key});

  /// The static route for ForgetPasswordPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
        builder: (_) => const ForgetPasswordPage());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => ForgetPasswordCubit(context.read()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Recuperar contraseña',
            style: textTheme.headline5?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          // TODO(lesanpi): Custom to ForgetPasswordPage
          leading: const CustomBackButton(),
        ),
        body: const ForgetPasswordView(),
      ),
    );
  }
}

/// {@template forget_password_view}
/// Displays the Body of ForgetPasswordView
/// {@endtemplate}
class ForgetPasswordView extends StatelessWidget {
  /// {@macro forget_password_view}
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state.step == ForgetPasswordStep.success) {
          Navigator.pushAndRemoveUntil(
              context, LoginPage.route(), (route) => false);
        }

        if (state.status.isSubmissionFailure && state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              NotificationSnackBar(
                textTheme: textTheme,
                title: 'Error!',
                body: state.errorMessage,
              ),
            );
        }

        if (state.status.isSubmissionSuccess && state.message.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              MessageSnackbar(
                textTheme: textTheme,
                title: '¡Éxito!',
                body: state.message,
              ),
            );
        }
      },
      child: ForgetPasswordBody(),
    );
  }
}
