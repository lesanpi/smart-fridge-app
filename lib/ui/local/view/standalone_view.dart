import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/ui/local/widgets/restore_fridge_button.dart';
import 'package:wifi_led_esp8266/ui/local/widgets/timer_compressor_view.dart';
import 'package:wifi_led_esp8266/ui/local/widgets/wifi_internet_view.dart';
import 'package:wifi_led_esp8266/widgets/output_card.dart';
import 'package:wifi_led_esp8266/widgets/toggle_card.dart';
import 'package:wifi_led_esp8266/widgets/widgets.dart';
import '../local.dart';

class StandaloneView extends StatelessWidget {
  const StandaloneView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<FridgeStateCubit, FridgeState?>(
      listener: (context, fridge) {},
      builder: (context, fridge) {
        if (fridge == null) {
          return const NoDataView();
        }
        // print(fridge.temperature.toString());
        return Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: Consts.defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // NameController(initialName: fridge.name),
                // const Text('Modo Independiente'),
                // Text(
                //   '#${fridge.id}',
                //   style: textTheme.headline6,
                // ),
                // Text(fridge.id),
                // const SizedBox(height: Consts.defaultPadding * 2),

                // Ready ✅
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        left: Consts.defaultPadding / 8,
                        right: Consts.defaultPadding / 8,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                Consts.borderRadius * 3,
                              ),
                            ),
                            color: Colors.blue.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: Consts.defaultPadding * 2),
                          Expanded(
                            child: Thermostat(
                              temperature: fridge.temperature,
                              alert: !(fridge.temperature >=
                                      fridge.minTemperature &&
                                  fridge.temperature <= fridge.maxTemperature),
                            ),
                          ),
                          const SizedBox(height: Consts.defaultPadding * 2),
                          NameController(initialName: fridge.name),
                          const SizedBox(height: Consts.defaultPadding * 2),
                        ],
                      ),
                    ],
                  ),
                ),

                // Ready ✅
                const SizedBox(height: Consts.defaultPadding * 1),
                const FridgeCompressor(),
                const SizedBox(height: Consts.defaultPadding * 1),
                const FridgeBattery(),
                const SizedBox(height: Consts.defaultPadding),
                const FridgeExternalTemperature(),
                const SizedBox(height: Consts.defaultPadding),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CheckCard(
                        messageFalse: 'Bateria de respaldo en uso',
                        messageTrue: 'Sin fallas eléctricas. Todo OK',
                        value: fridge.batteryOn,
                        text: 'Electricidad',
                      ),
                    ),
                    const SizedBox(width: Consts.defaultPadding / 2),
                    Expanded(
                      child: ToggleCard(
                        onChanged: (value) {
                          context.read<FridgeStateCubit>().toggleLight();
                        },
                        value: fridge.light,
                        text: 'Luz',
                      ),
                    ),
                    // const Spacer(),
                    // const SizedBox(
                    //   width: Consts.defaultPadding,
                    // ),
                  ],
                ),

                const TemperatureParameterView(),
                const TimeCompressorView(),
                const SizedBox(height: Consts.defaultPadding * 1),
                const CommunicationModeView(),
                const SizedBox(height: Consts.defaultPadding),
                const WifiInternetView(),
                const SizedBox(height: Consts.defaultPadding * 2),
                const RestoreFridgeButton(),
                const SizedBox(height: Consts.defaultPadding / 2),
                DisconnectButton(
                  onTap: () => context.read<FridgeStateCubit>().disconnect(),
                ),
                const SizedBox(height: Consts.defaultPadding * 2),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FridgeBattery extends StatelessWidget {
  const FridgeBattery({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FridgeStateCubit, FridgeState?>(
      builder: (context, fridge) {
        if (fridge == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '🔋 Batería de respaldo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                IconButton(
                  splashRadius: 10,
                  tooltip: 'Porcentaje de carga de la batería',
                  onPressed: () {},
                  icon: const Icon(
                    Icons.info,
                    color: Consts.fontDark,
                  ),
                )
              ],
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.all(Consts.defaultPadding),
              // elevation: 3,
              decoration: BoxDecoration(
                color: Consts.primary.shade800.withOpacity(0.5),
                borderRadius: const BorderRadius.all(
                    Radius.circular(Consts.borderRadius * 3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        // const Text(
                        //   '🔋',
                        //   style: TextStyle(fontSize: 30),
                        // ),
                        const Icon(Icons.battery_charging_full),
                        Text(
                          'Nivel de carga',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${fridge.batteryPorcentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withOpacity(0.9),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

class FridgeExternalTemperature extends StatelessWidget {
  const FridgeExternalTemperature({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FridgeStateCubit, FridgeState?>(
      builder: (context, fridge) {
        if (fridge == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🌡️ Temperatura Externa',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            const Text(
                'Indica el valor de la temperatura ambiente del lugar donde se encuentra el dispositivo.'),
            const SizedBox(height: Consts.defaultPadding / 2),
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.all(Consts.defaultPadding),
              // elevation: 3,
              decoration: BoxDecoration(
                color: Consts.primary.shade800.withOpacity(0.1),
                borderRadius: const BorderRadius.all(
                    Radius.circular(Consts.borderRadius * 3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Temperatura Externa',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.9),
                      ),
                    ),
                  ),
                  Text(
                    '${fridge.externalTemperature.toStringAsFixed(0)} °C',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withOpacity(0.9),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

class LightButton extends StatelessWidget {
  const LightButton(this.selected, {Key? key}) : super(key: key);
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return ButtonAction(
      onTap: () {
        context.read<FridgeStateCubit>().toggleLight();
      },
      selected: selected,
      iconData: Icons.lightbulb,
      description: 'Luz',
    );
  }
}

class NameController extends StatefulWidget {
  const NameController({Key? key, required this.initialName}) : super(key: key);
  final String initialName;
  @override
  State<NameController> createState() => _NameControllerState();
}

class _NameControllerState extends State<NameController> {
  late TextEditingController nameController =
      TextEditingController(text: widget.initialName);
  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return BlocBuilder<FridgeStateCubit, FridgeState?>(
      builder: (context, state) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (state!.name != nameController.text) ...[
                GestureDetector(
                  onTap: () => nameController.text = state.name,
                  child: const Icon(
                    Icons.restart_alt,
                    size: 30,
                    color: Consts.primary,
                  ),
                ),
                const SizedBox(width: Consts.defaultPadding / 2),
              ], // else
              //   const SizedBox(width: 40),
              Material(
                elevation: 20,
                shadowColor: Colors.black45,
                borderRadius: const BorderRadius.all(
                    Radius.circular(Consts.borderRadius * 3)),
                child: Container(
                  width: size.width * 0.65,
                  padding: const EdgeInsets.all(Consts.defaultPadding / 2),
                  decoration: BoxDecoration(
                    color: Consts.neutral.shade100,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(Consts.borderRadius * 3)),
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Consts.primary,
                        ),
                      ),
                      fillColor: Consts.neutral.shade100,
                      // suffixIcon: Icon(
                      //   Icons.edit,
                      //   size: 25,
                      //   color: Consts.primary,
                      // ),
                    ),
                    style: TextStyle(
                      color: Consts.neutral.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 27,
                    ),
                    controller: nameController,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (name) {
                      if (state.name != nameController.text &&
                          name.isNotEmpty) {
                        context.read<FridgeStateCubit>().changeName(name);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FridgeCompressor extends StatelessWidget {
  const FridgeCompressor({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FridgeStateCubit, FridgeState?>(
      builder: (context, fridge) {
        if (fridge == null) return const SizedBox.shrink();

        return OutputCard(
          title: '🧊 Compresor',
          onText: 'Encendido',
          offText: 'Apagado',
          tooltipText: 'Indica si el compresor esta encendido o no',
          output: fridge.compressor,
          color: Colors.lightBlue.shade200.withOpacity(0.3),
          icon: Icons.ac_unit,
        );
      },
    );
  }
}

class FridgeLightElectricity extends StatelessWidget {
  const FridgeLightElectricity({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FridgeStateCubit, FridgeState?>(
      builder: (context, fridge) {
        if (fridge == null) return const SizedBox.shrink();

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CheckCard(
                messageFalse: 'Bateria de respaldo en uso',
                messageTrue: 'Sin fallas eléctricas. Todo OK',
                value: fridge.batteryOn,
                text: 'Electricidad',
                tooltipText: 'Indica si hay una falla eléctrica o no.',
              ),
            ),
            const SizedBox(width: Consts.defaultPadding / 2),
            Expanded(
              child: ToggleCard(
                onChanged: (value) {
                  context.read<FridgeStateCubit>().toggleLight();
                },
                value: fridge.light,
                text: 'Luz',
                tooltipText: 'Indica si la luz del equipo esta encendida.',
              ),
            ),

            // const Spacer(),
          ],
        );
      },
    );
  }
}
