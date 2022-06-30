import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/local/cubit/connection_cubit.dart';
import 'package:wifi_led_esp8266/ui/local/cubit/fridge_state_cubit.dart';
import 'package:wifi_led_esp8266/ui/local/local.dart';

class DisconnectedView extends StatelessWidget {
  const DisconnectedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Consts.defaultPadding * 3,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 100,
              color: Consts.primary,
            ),
            const SizedBox(height: Consts.defaultPadding),
            Text(
              "Desconectado",
              style: textTheme.headline3?.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Colors.black38,
              ),
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            Text(
              "Asegurate de estar conectado a la red WiFi correcta",
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Consts.defaultPadding),
            ElevatedButton(
              onPressed: () async {
                await context.read<ConnectionCubit>().connect('');

                // context.read<ConnectionCubit>().connect('').then((_) {
                //   context.read<ConnectionCubit>().connect('');
                //   context.read<ConnectionCubit>().connect('');
                // });
              },
              child: const Text(
                "Conectarse",
              ),
            )
          ],
        ),
      ),
    );
  }
}
