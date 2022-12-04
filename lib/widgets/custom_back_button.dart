import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        overlayColor: MaterialStateProperty.all(Consts.primary.shade300),
        onTap: () => Navigator.maybePop(context),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            Consts.borderRadius * 2,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Consts.primary.shade300,
              width: 2,
            ),
            color: Consts.primary.shade100.withOpacity(0.5),
            borderRadius: const BorderRadius.all(
              Radius.circular(
                Consts.borderRadius * 2,
              ),
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Consts.primary,
            size: 20,
          ),
        ),
      ),
    );
  }
}
