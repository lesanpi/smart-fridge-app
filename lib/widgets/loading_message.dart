import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';

class LoadingMessage extends StatelessWidget {
  const LoadingMessage({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
            strokeWidth: 10,
            color: Consts.accent,
          ),
        ),
        const SizedBox(height: Consts.defaultPadding * 2),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1000),
          duration: const Duration(seconds: 1000),
          builder: (context, value, _) {
            final dotsNum = (value.toInt()) % 4;
            return Text(
              'Cargando${'.' * dotsNum}',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Consts.neutral.shade700,
                fontSize: 25,
              ),
            );
          },
        ),
      ],
    );
  }
}
