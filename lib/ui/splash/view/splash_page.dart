import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/auth/auth.dart';
import 'package:wifi_led_esp8266/ui/auth/view/sign_in_page.dart';
import 'package:wifi_led_esp8266/ui/auth/view/sign_up_page.dart';
import 'package:wifi_led_esp8266/ui/home/home.dart';

import '../cubit/splash_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (_context) => SplashCubit(_context.read())..init(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          /// Listening if the cubit emits a new state that will determinate
          /// if the user exists or not
          if (state == SplashState.none) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const SignInPage(),
              ),
            );
          }

          if (state == SplashState.existingUser) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const HomePage(),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Consts.lightSystem.shade300,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.ac_unit_rounded,
                  color: Consts.accent.shade400,
                  size: 100,
                ),
                const SizedBox(height: Consts.defaultPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Zona",
                      style: textTheme.headline3
                          ?.copyWith(color: Consts.accent.shade400),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Refri",
                      style: textTheme.headline3
                          ?.copyWith(color: Consts.neutral.shade500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
