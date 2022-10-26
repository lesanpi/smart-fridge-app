import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/cloud/cloud.dart';
import 'package:wifi_led_esp8266/ui/cloud/widgets/disconnect_button.dart';
import 'package:wifi_led_esp8266/ui/local/widgets/disconnect_button.dart';

class FridgesEmpty extends StatelessWidget {
  const FridgesEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Consts.defaultPadding,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/empty.jpg'),
            // const SizedBox(height: Consts.defaultPadding),
            Text(
              "No hay neveras conectadas",
              style: textTheme.headline5?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            Text(
              "Configura tus controladores en Modo Coordinado, para que se conecten a Internet y puedan ser monitoreadas y controladas remotamente",
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 3 * Consts.defaultPadding),
            const CloudDisconnectButton(),
            const SizedBox(height: Consts.defaultPadding),
          ],
        ),
      ),
    );
  }
}
