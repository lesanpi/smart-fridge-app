import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/models/wifi_internet.dart';
import 'package:wifi_led_esp8266/ui/local/cubit/internet_cubit.dart';
import 'package:wifi_led_esp8266/ui/local/local.dart';
import 'package:wifi_led_esp8266/widgets/future_loading_indicator.dart';

class WifiInternetView extends StatelessWidget {
  const WifiInternetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WifiInternetCubit(
        WifiInternet.fromFridgeState(
          context.read<FridgeStateCubit>().state,
        ),
      ),
      child: BlocBuilder<FridgeStateCubit, FridgeState?>(
        builder: (context, fridgeState) {
          return BlocBuilder<WifiInternetCubit, WifiInternet>(
            builder: (context, wifiInternetState) {
              final initialWifiInternet =
                  WifiInternet.fromFridgeState(fridgeState);

              return Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.wifi,
                        color: Consts.primary.shade600,
                      ),
                      const SizedBox(
                        width: Consts.defaultPadding / 2,
                      ),
                      const Expanded(
                        child: Text(
                          "WiFi",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 26,
                            color: Consts.fontDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    '¡Comunicate con tu equipo desde cualquier lugar! Para eso tienes que indicarle cual es la red WiFi con conexión a internet.',
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: Consts.defaultPadding),
                  WifiInternetController(
                    wifiInternet: wifiInternetState,
                    wifiInternetInitial: initialWifiInternet,
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class WifiInternetController extends StatefulWidget {
  const WifiInternetController({
    Key? key,
    required this.wifiInternet,
    required this.wifiInternetInitial,
  }) : super(key: key);
  final WifiInternet wifiInternet;
  final WifiInternet wifiInternetInitial;

  @override
  State<WifiInternetController> createState() => _WifiInternetControllerState();
}

class _WifiInternetControllerState extends State<WifiInternetController> {
  late final TextEditingController ssidInternetController =
      TextEditingController(text: widget.wifiInternet.ssid);
  late final TextEditingController passwordInternetController =
      TextEditingController(text: widget.wifiInternet.password);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WifiInternetCubit, WifiInternet>(
      builder: (context, wifiInternet) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nombre del WiFi con Internet',
              style: TextStyle(
                color: Consts.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            TextField(
              controller: ssidInternetController,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                // border: OutlineInputBorder(),
                hintText: 'Nombre del WiFi con Internet',
              ),
              onChanged: context.read<WifiInternetCubit>().onChangedSsid,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            const Text(
              'Contraseña del WiFi con Internet',
              style: TextStyle(
                color: Consts.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            TextField(
              controller: passwordInternetController,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                // border: OutlineInputBorder(),

                hintText: 'Contraseña del WiFi (Internet)',
              ),
              obscureText: true,
              onChanged: context.read<WifiInternetCubit>().onChangedPassword,
            ),
            const SizedBox(height: Consts.defaultPadding),
            Center(
              child: ElevatedButton(
                onPressed: widget.wifiInternet == widget.wifiInternetInitial ||
                        widget.wifiInternet.password.length < 8
                    ? null
                    : () => onDialogMessage(
                          context: context,
                          title: '¡Advertencia!',
                          message:
                              'Realizar este cambio lo desconectara de la red Wifi con internet, lo que puede inhabilitar las comunicaciones por internet por unos instantes',
                          warning: true,
                          warningButtonText: 'EJECUTAR',
                          warningCallback: () => context
                              .read<FridgeStateCubit>()
                              .setInternet(wifiInternet),
                        ),
                child: const Text("Cambiar Wifi Internet"),
              ),
            ),
          ],
        );
      },
    );
  }
}
