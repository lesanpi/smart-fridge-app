import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/connection_info.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/widgets/widgets.dart';

import '../local.dart';

class LocalPage extends StatelessWidget {
  const LocalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ConnectionCubit(
            context.read(),
            context.read(),
          )..init(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => FridgeStateCubit(context.read())..init(),
          lazy: false,
        ),
        // BlocProvider(
        //   create: (context) => FridgesCubit(context.read())..init(),
        // ),
      ],
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: LocalAppBar(),
        ),
        backgroundColor: Consts.lightSystem.shade300,
        body: const SafeArea(
          child: LocalView(),
        ),
      ),
    );
  }
}

class LocalView extends StatelessWidget {
  const LocalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectionCubit, ConnectionInfo?>(
      listener: (context, connectionInfo) {
        if (connectionInfo == null) return;

        if (connectionInfo.standalone) {
          context.read<FridgeStateCubit>().init();
        } else {
          // context.read<FridgesCubit>().init();
        }
      },
      builder: (context, connectionInfo) {
        if (connectionInfo == null) {
          return const DisconnectedView();
        }

        if (connectionInfo.standalone) {
          return const StandaloneView();
        }

        return const CoordinatorView();
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
