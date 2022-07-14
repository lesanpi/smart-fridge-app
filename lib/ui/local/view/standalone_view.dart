import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
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
        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NameController(initialName: fridge.name),
                const Text('Modo Independiente'),
                Text(
                  fridge.id,
                  style: textTheme.headline2,
                ),
                Text(fridge.id),
                const SizedBox(height: Consts.defaultPadding * 2),
                Thermostat(temperature: fridge.temperature),
                const SizedBox(height: Consts.defaultPadding * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LightButton(fridge.light),
                    const SizedBox(
                      width: Consts.defaultPadding,
                    ),
                    ButtonAction(
                      onTap: () {},
                      selected: fridge.compressor,
                      iconData: Icons.ac_unit_outlined,
                      description: 'Compresor',
                    ),
                    const SizedBox(
                      width: Consts.defaultPadding,
                    ),
                    ButtonAction(
                      onTap: () {},
                      selected: fridge.door,
                      iconData: Icons.door_front_door_outlined,
                      description: 'Puerta',
                    )
                  ],
                ),
                const SizedBox(height: Consts.defaultPadding * 2),
                const TemperatureParameterView(),
                const SizedBox(height: Consts.defaultPadding * 2),
                const CommunicationModeView(),
                const SizedBox(height: Consts.defaultPadding * 2),
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
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state!.name != nameController.text)
                  GestureDetector(
                    onTap: () => nameController.text = state.name,
                    child: Icon(
                      Icons.restart_alt,
                      size: 30,
                      color: Consts.primary.shade600,
                    ),
                  )
                else
                  const SizedBox(width: 40),
                SizedBox(
                  width: size.width * 0.65,
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Consts.primary.shade600,
                        ),
                      ),
                      suffixIcon: Icon(
                        Icons.edit,
                        size: 25,
                        color: Consts.primary.shade600,
                      ),
                    ),
                    style: textTheme.headline2?.copyWith(
                      color: Consts.primary.shade600,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
