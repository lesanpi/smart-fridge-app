import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:wifi_led_esp8266/ui/login/login.dart';
import 'package:wifi_led_esp8266/ui/navigation/navigation.dart';
import 'package:wifi_led_esp8266/widgets/widgets.dart';

import '../../home/view/home_page.dart';

/// {@template login_page}
/// A description for LoginPage
/// {@endtemplate}
class LoginPage extends StatelessWidget {
  /// {@macro login_page}
  const LoginPage({super.key});

  /// The static route for LoginPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocProvider(
      create: (context) => LoginCubit(context.read()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Iniciar sesión',
            style: textTheme.headline5?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: const LoginView(),
      ),
    );
  }
}

/// {@template login_view}
/// Displays the Body of LoginView
/// {@endtemplate}
class LoginView extends StatelessWidget {
  /// {@macro login_view}
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state.status.isSubmissionFailure) {
          await onDialogMessage(
            context: context,
            title: 'Hubo un problema...',
            message: state.errorMessage.isEmpty
                ? state.errorMessage
                : 'Occurió un error desconocido',
            warning: true,
            warningCallback: () {
              context.read<LoginCubit>().loginButtonPressed();
            },
          );
        }

        if (state.status.isSubmissionSuccess) {
          Navigator.pushReplacement(
            context,
            NavigationPage.route(),
          );
        }
      },
      child: LoginBody(),
    );
  }
}
