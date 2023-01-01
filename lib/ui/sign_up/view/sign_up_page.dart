import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:wifi_led_esp8266/ui/sign_up/sign_up.dart';
import 'package:wifi_led_esp8266/widgets/widgets.dart';

/// {@template sign_up_page}
/// A description for SignUpPage
/// {@endtemplate}
class SignUpPage extends StatelessWidget {
  /// {@macro sign_up_page}
  const SignUpPage({super.key});

  /// The static route for SignUpPage
  static Route<dynamic> route() {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => const SignUpPage(),
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: const Offset(1, 0), end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => SignUpCubit(context.read()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 80,
          // leading: const CustomBackButton(),
          centerTitle: true,
          toolbarHeight: 0,
          // centerTitle: true,
          title: Text(
            '',
            style: textTheme.headline5?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: const SignUpView(),
      ),
    );
  }
}

/// {@template sign_up_view}
/// Displays the Body of SignUpView
/// {@endtemplate}
class SignUpView extends StatelessWidget {
  /// {@macro sign_up_view}
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
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
              context.read<SignUpCubit>().signUp();
            },
          );
        }

        if (state.status.isSubmissionSuccess) {
          Navigator.pop(context);
        }
      },
      child: SignUpBody(),
    );
  }
}
