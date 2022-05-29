import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wifi_led_esp8266/consts.dart';

/// Custom loading indicator container for futures.
class LoadingIndicator extends StatelessWidget {
  final Color backgroundColor;
  const LoadingIndicator({
    Key? key,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeInCubic,
      builder: (context, scale, _) {
        return Transform.scale(
          scale: scale,
          child: Center(
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(Consts.defaultBorderRadius),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // CircularProgressIndicator(color: Consts.primary),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 0.1),
                      curve: Curves.bounceInOut,
                      duration: const Duration(seconds: 3),
                      builder: (context, value, _) {
                        return Transform.rotate(
                          angle: (pi) * value,
                          child: const Icon(
                            Icons.ac_unit_outlined,
                            size: 80,
                            color: Consts.primary,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: Consts.defaultPadding / 2),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 15.0),
                      duration: const Duration(seconds: 10),
                      builder: (context, value, _) {
                        int dotsNum = ((value.toInt()) % 3 + 1).toInt();
                        return Text(
                          'Cargando' + '.' * dotsNum,
                          style: Theme.of(context)
                              .textTheme
                              .button
                              ?.copyWith(color: Consts.primary.shade400),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
