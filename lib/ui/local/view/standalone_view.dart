import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/ui/local/widgets/restore_fridge_button.dart';
import 'package:wifi_led_esp8266/ui/local/widgets/wifi_internet_view.dart';
import 'package:wifi_led_esp8266/widgets/output_card.dart';
import 'package:wifi_led_esp8266/widgets/toggle_card.dart';
import 'package:wifi_led_esp8266/widgets/widgets.dart';
import '../local.dart';

class StandaloneView extends StatelessWidget {
  const StandaloneView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
                OutputCard(
                  title: 'Compresor',
                  onText: 'Encendido',
                  offText: 'Apagado',
                  output: fridge.compressor,
                  color: Colors.lightBlue.shade200.withOpacity(0.3),
                  icon: Icons.ac_unit,
                ),

                // Ready ✅
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
                const SizedBox(height: Consts.defaultPadding * 2),
                const CommunicationModeView(),
                const SizedBox(height: Consts.defaultPadding * 2),
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
    final textTheme = Theme.of(context).textTheme;
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
