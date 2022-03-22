import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/pages/local_home_page.dart';
import 'package:wifi_led_esp8266/utils/custom_clippers.dart';
import 'package:wifi_led_esp8266/utils/utils.dart';
import 'dart:math';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation _animation;

  final double width = 100.0;
  final Duration transitionDuration = Duration(milliseconds: 2000);
  final Duration splashDuration = Duration(milliseconds: 3000);

  void waitAndNavigate() async {
    await Future.delayed(splashDuration);
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: transitionDuration,
        pageBuilder: (context, animation, _) {
          return FadeTransition(
            opacity: animation,
            child: LocalHomePage(),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    _logoController =
        AnimationController(vsync: this, duration: transitionDuration);
    super.initState();
    waitAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Transform.rotate(
          //   angle: 0,
          //   child: ClipPath(
          //     clipper: MyCustomShape(),
          //     child: Container(
          //       color: darkGreen.withOpacity(0.8),
          //     ),
          //   ),
          // ),
          TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: transitionDuration,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Center(
                    child: Transform.scale(
                      scale: 2,
                      child: Hero(
                        tag: "logo_hero",
                        child: Image.asset(
                          'assets/images/icon.png',
                        ),
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
