import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/models/wifi_internet.dart';
import 'package:wifi_led_esp8266/ui/cloud/cubit/fridge_state_cubit.dart';
import 'package:wifi_led_esp8266/ui/cloud/cubit/internet_cubit.dart';
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

              print('initial from fridgeState $initialWifiInternet');
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Consts.defaultPadding),
                child: Column(
                  children: [
                    // Center(
                    //   child: ElevatedButton(
                    //     onPressed: wifiInternetState == initialWifiInternet
                    //         ? null
                    //         : () {
                    //             context
                    //                 .read<WifiInternetCubit>()
                    //                 .set(fridgeState!);
                    //           },
                    //     child: const Text("Deshacer cambios"),
                    //   ),
                    // ),
                    const SizedBox(height: Consts.defaultPadding),
                    WifiInternetController(
                      wifiInternet: wifiInternetState,
                      wifiInternetInitial: initialWifiInternet,
                    )
                  ],
                ),
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
        return Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Consts.defaultPadding),
          child: Column(
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
                  onPressed: widget.wifiInternet == widget.wifiInternetInitial
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
          ),
        );
      },
    );
  }
}
