import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/ui/local/bloc/connection_bloc.dart';
import 'package:wifi_led_esp8266/widgets/widgets.dart';

import '../local.dart';

class LocalPage extends StatelessWidget {
  const LocalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocalConnectionBloc(
            context.read(),
            context.read(),
          )..add(LocalConnectionInit()),
          lazy: false,
        ),
        BlocProvider(
          create: (context) =>
              FridgeStateCubit(context.read(), context.read())..init(),
          lazy: false,
        ),
        // BlocProvider(
        //   create: (context) => FridgesCubit(context.read())..init(),
        // ),
      ],
      child: const Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: LocalAppBar(),
        ),
        // backgroundColor: Consts.lightSystem.shade300,
        body: SafeArea(
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
    final textTheme = Theme.of(context).textTheme;
    return BlocConsumer<LocalConnectionBloc, LocalConnectionState>(
      listener: (context, state) {
        if (state.connectionInfo == null) return;

        if (state.connectionInfo!.standalone) {
          context.read<FridgeStateCubit>().init();
        } else {
          // context.read<FridgesCubit>().init();
        }
      },
      builder: (context, state) {
        if (state is LocalConnectionLoading) {
          return const Center(
            child: LoadingMessage(),
          );
        }
        if (state is LocalConnectionDisconnected) {
          return const DisconnectedView();
        }
        final connectionNull = state.connectionInfo == null;
        if (state is LocalConnectionWaiting) {
          // print(state.connectionInfo);
          if (!connectionNull) {
            if (state.connectionInfo!.configurationMode) {
              return const ConfigurationModeMessage();
            }
          }
          return const NoDataView();
        }

        if (!connectionNull) {
          if (state.connectionInfo!.configurationMode) {
            return const ConfigurationModeMessage();
          }
        }

        if (connectionNull) {
          return const DisconnectedView();
        }

        if (state.connectionInfo!.standalone) {
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
                Thermostat(
                  temperature: fridge.temperature,
                  alert: !(fridge.temperature >= fridge.minTemperature &&
                      fridge.temperature <= fridge.maxTemperature),
                ),
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

class ConfigurationModeMessage extends StatelessWidget {
  const ConfigurationModeMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Consts.defaultPadding * 2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.settings,
              size: 100,
              color: Consts.primary,
            ),
            const SizedBox(height: Consts.defaultPadding),
            Text(
              "Atención!",
              style: textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            Text(
              '''Estas intentando ingresar a un dispositivo en modo configuración. Asegurate que tu dispositivo este configurado.''',
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Consts.defaultPadding),
            DisconnectButton(
              onTap: () => context
                  .read<LocalConnectionBloc>()
                  .add(LocalConnectionDisconnect()),
            ),
          ],
        ),
      ),
    );
  }
}
