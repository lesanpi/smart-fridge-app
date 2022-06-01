import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/model/connection_info.dart';
import 'package:wifi_led_esp8266/model/fridge_state.dart';
import 'package:wifi_led_esp8266/ui/local/cubit/connection_cubit.dart';
import 'package:wifi_led_esp8266/ui/local/cubit/fridge_state_cubit.dart';
import 'package:wifi_led_esp8266/ui/local/view/disconnect_button.dart';
import 'package:wifi_led_esp8266/ui/local/view/disconnect_view.dart';
import 'package:wifi_led_esp8266/ui/local/view/no_data_view.dart';
import 'package:wifi_led_esp8266/ui/local/view/standalone_fridge_view.dart';
import 'package:wifi_led_esp8266/widgets/button_action.dart';
import 'package:wifi_led_esp8266/widgets/thermostat.dart';

class LocalView extends StatelessWidget {
  const LocalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FridgeStateCubit(context.read())..init(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => ConnectionCubit(
            context.read(),
            context.read(),
          )..init(),
        ),
      ],
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: LocalAppBar(),
        ),
        backgroundColor: Consts.lightSystem.shade300,
        body: const SafeArea(
          child: LocalConnectionView(),
        ),
      ),
    );
  }
}

class LocalAppBar extends StatelessWidget {
  const LocalAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Consts.lightSystem.shade300,
      leading: BackButton(color: Consts.neutral.shade700),
      centerTitle: true,
      title: BlocBuilder<ConnectionCubit, ConnectionInfo?>(
        builder: (context, connectionInfo) {
          return Text(
            connectionInfo != null ? "Conectado" : "Desconectado",
            style: TextStyle(
              color: Consts.neutral.shade700,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }
}

class LocalConnectionView extends StatelessWidget {
  const LocalConnectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectionCubit, ConnectionInfo?>(
      listener: (context, connectionInfo) {
        if (connectionInfo == null) return;

        if (connectionInfo.standalone) {
          context.read<FridgeStateCubit>().init();
        }
      },
      builder: (context, connectionInfo) {
        if (connectionInfo == null) {
          return const DisconnectedView();
        }

        if (connectionInfo.standalone) {
          return const StandaloneFridgeView();
        }

        return const FridgeListView();
      },
    );
  }
}

class FridgeView extends StatelessWidget {
  const FridgeView({Key? key}) : super(key: key);

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
                    ButtonAction(
                      onTap: () {
                        // localRepository.toggleLight(widget.fridgeState.id);
                      },
                      selected: fridge.light,
                      iconData: Icons.lightbulb,
                      description: 'Luz',
                    ),
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
                DisconnectButton(
                  onTap: () => context.read<FridgeStateCubit>().disconnect(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FridgeListView extends StatelessWidget {
  const FridgeListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('connected'),
          DisconnectButton(),
        ],
      ),
    );
  }
}
