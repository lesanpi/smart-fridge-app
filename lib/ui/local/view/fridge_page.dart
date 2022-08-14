import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/data/repositories/local_repository.dart';
import '../local.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/widgets/widgets.dart';

class FridgePage extends StatelessWidget {
  const FridgePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => FridgeStateCubit(context.read())..init(),
      lazy: false,
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: FridgeAppBar(),
        ),
        backgroundColor: Consts.lightSystem.shade300,
        body: SafeArea(
          child: BlocBuilder<FridgeStateCubit, FridgeState?>(
            builder: (context, fridge) {
              if (fridge == null) {
                return const NoDataView();
              }

              print(fridge.temperature);

              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: Consts.defaultPadding),
                      NameController(initialName: fridge.name),
                      Text(
                        '#${fridge.id}',
                        style: textTheme.headline6,
                      ),
                      const SizedBox(height: Consts.defaultPadding * 1),
                      Thermostat(
                        temperature:
                            fridge.temperature.toStringAsFixed(2) as double,
                        alert: !(fridge.temperature >= fridge.minTemperature &&
                            fridge.temperature <= fridge.maxTemperature),
                      ),
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
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class FridgeAppBar extends StatelessWidget {
  const FridgeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<FridgeStateCubit, FridgeState?>(
      builder: (context, fridge) {
        return AppBar(
          backgroundColor: Consts.lightSystem.shade300,
          elevation: 0,
          centerTitle: true,
          title: Text(
            fridge?.name ?? "",
            style: TextStyle(
              color: Consts.neutral.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: BackButton(
            color: Consts.neutral.shade700,
            onPressed: () {
              RepositoryProvider.of<LocalRepository>(context).unselectFridge();
              Navigator.maybePop(context);
            },
          ),
        );
      },
    );
  }
}
