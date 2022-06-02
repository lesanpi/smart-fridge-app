import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/model/fridge_state.dart';
import 'package:wifi_led_esp8266/ui/local/cubit/fridge_state_cubit.dart';
import 'package:wifi_led_esp8266/ui/local/view/disconnect_button.dart';
import 'package:wifi_led_esp8266/ui/local/view/no_data_view.dart';
import 'package:wifi_led_esp8266/ui/comunication_mode/view/communication_mode_view.dart';
import 'package:wifi_led_esp8266/ui/temperature_parameter/temperature_parameter.dart';
import 'package:wifi_led_esp8266/widgets/button_action.dart';
import 'package:wifi_led_esp8266/widgets/thermostat.dart';

class StandaloneFridgeView extends StatelessWidget {
  const StandaloneFridgeView({Key? key}) : super(key: key);

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
                const SizedBox(height: Consts.defaultPadding * 2),
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
