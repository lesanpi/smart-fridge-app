import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';

class LoadingButton extends StatelessWidget {
  /// {@macro loading_row_widget}
  const LoadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
        SizedBox(width: Consts.defaultPadding / 2),
        Text('Cargando...'),
      ],
    );
  }
}
