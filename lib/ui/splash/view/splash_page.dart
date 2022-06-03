import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/auth/auth.dart';
import 'package:wifi_led_esp8266/ui/home/home.dart';

import '../cubit/splash_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_context) => SplashCubit(_context.read())..init(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          /// Listening if the cubit emits a new state that will determinate
          /// if the user exists or not
          if (state == SplashState.none) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const AuthPage(),
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
              children: const [
                Text(
                  "Splash Page",
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
