import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/local/bloc/connection_bloc.dart';

class DisconnectedView extends StatelessWidget {
  const DisconnectedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Consts.defaultPadding,
      ),
      child: IntrinsicWidth(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/images/empty.jpg'),
            // const SizedBox(height: Consts.defaultPadding),
            Text(
              "🔌 Desconectado",
              style: textTheme.headlineSmall?.copyWith(
                // fontSize: 30,
                fontWeight: FontWeight.w600,
                // color: Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            Text(
              "Asegurate de estar conectado a la red WiFi correcta",
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Consts.defaultPadding),
            ElevatedButton(
              // style: Theme.of(context).elevatedButtonTheme.style,
              onPressed: () {
                context
                    .read<LocalConnectionBloc>()
                    .add(LocalConnectionConnect());

                // context.read<ConnectionCubit>().connect('').then((_) {
                //   context.read<ConnectionCubit>().connect('');
                //   context.read<ConnectionCubit>().connect('');
                // });
              },
              child: const Text(
                "Conectarse",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
