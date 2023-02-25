import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/cloud/bloc/connection_bloc.dart';

class DisconnectedView extends StatelessWidget {
  const DisconnectedView({Key? key}) : super(key: key);

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/empty.jpg'),
            // const SizedBox(height: Consts.defaultPadding),
            Text(
              "🔌 Desconectado",
              style: textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            Text(
              "Conectate a las neveras de forma remota. Asegurate de tener una conexión de internet estable",
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Consts.defaultPadding),
            ElevatedButton(
              onPressed: () {
                context
                    .read<CloudConnectionBloc>()
                    .add(CloudConnectionConnect());

                // context.read<ConnectionCubit>().connect('').then((_) {
                //   context.read<ConnectionCubit>().connect('');
                //   context.read<ConnectionCubit>().connect('');
                // });
              },
              child: const Center(
                child: Text(
                  "Conectarse",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
