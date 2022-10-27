import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/data/repositories/cloud_repository.dart';
import 'package:wifi_led_esp8266/models/temperature_stat.dart';
import 'package:wifi_led_esp8266/ui/cloud/bloc/temperature_stats_bloc/temperature_stats_bloc.dart';
import 'package:wifi_led_esp8266/ui/cloud/widgets/restore_fridge_button.dart';
import 'package:wifi_led_esp8266/ui/cloud/widgets/wifi_internet_view.dart';
import 'package:wifi_led_esp8266/widgets/custom_back_button.dart';
import 'package:wifi_led_esp8266/widgets/output_card.dart';
import 'package:wifi_led_esp8266/widgets/toggle_card.dart';
import '../cloud.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/widgets/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class FridgePage extends StatelessWidget {
  const FridgePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) =>
          FridgeStateCubit(context.read(), context.read())..init(),
      lazy: false,
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: FridgeAppBar(),
        ),
        // backgroundColor: Consts.lightSystem.shade300,
        body: SafeArea(
          child: BlocBuilder<FridgeStateCubit, FridgeState?>(
            builder: (context, fridge) {
              if (fridge == null) {
                return const NoDataView();
              }

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Consts.defaultPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // const SizedBox(height: Consts.defaultPadding),
                      // Text(
                      //   '#${fridge.id}',
                      //   style: textTheme.headline6,
                      // ),
                      // const SizedBox(height: Consts.defaultPadding * 1),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              left: Consts.defaultPadding / 4,
                              right: Consts.defaultPadding / 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                          Consts.borderRadius * 15)),
                                  color: Colors.blue.withOpacity(0.1),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                    height: Consts.defaultPadding * 2),
                                Expanded(
                                  child: Thermostat(
                                    temperature: fridge.temperature,
                                    alert: !(fridge.temperature >=
                                            fridge.minTemperature &&
                                        fridge.temperature <=
                                            fridge.maxTemperature),
                                  ),
                                ),
                                const SizedBox(
                                    height: Consts.defaultPadding * 2),
                                NameController(initialName: fridge.name),
                                const SizedBox(
                                    height: Consts.defaultPadding * 2),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Consts.defaultPadding * 2),
                      OutputCard(
                        title: 'Compresor',
                        onText: 'Encendido',
                        offText: 'Apagado',
                        output: fridge.compressor,
                        color: Colors.lightBlue.shade200.withOpacity(0.3),
                        icon: Icons.ac_unit,
                      ),
                      const SizedBox(height: Consts.defaultPadding),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ToggleCard(
                              onChanged: (value) {
                                context.read<FridgeStateCubit>().toggleLight();
                              },
                              value: fridge.light,
                              text: 'Luz',
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(
                            width: Consts.defaultPadding,
                          ),
                        ],
                      ),

                      const TemperatureParameterView(),
                      const SizedBox(height: Consts.defaultPadding * 2),
                      const WifiInternetView(),
                      const SizedBox(height: Consts.defaultPadding * 2),
                      Row(children: [
                        Expanded(
                            child: Text(
                          "Temperatura vs Tiempo",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 26,
                            color: Consts.primary.shade600,
                          ),
                        ))
                      ]),
                      FridgeStats(fridgeId: fridge.id),
                      const SizedBox(height: Consts.defaultPadding * 2),
                      const RestoreFridgeButton(),
                      const SizedBox(height: Consts.defaultPadding * 3),
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
          // backgroundColor: Consts.lightSystem.shade300,
          elevation: 0,
          centerTitle: true,
          title: Text(
            fridge?.name ?? "Sin conexión",
            style: TextStyle(
              color: Consts.neutral.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
          leading: const CustomBackButton(),
        );
      },
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

class FridgeStats extends StatelessWidget {
  const FridgeStats({Key? key, required this.fridgeId}) : super(key: key);
  final String fridgeId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocProvider(
      create: (context) => TemperatureStatsBloc(context.read(), fridgeId)
        ..add(TemperatureStatsGet()),
      child: BlocBuilder<TemperatureStatsBloc, TemperatureStatsState>(
        builder: (context, state) {
          if (state is TemperatureStatsLoading ||
              state is TemperatureStatsInitial) {
            return const LoadingMessage();
          }

          if (state is TemperatureStatsFailed) {
            return const Center(
              child: Text('Ocurrió un error'),
            );
          }

          if (state.stats.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/empty.jpg'),
                  // const SizedBox(height: Consts.defaultPadding),
                  Text(
                    "Sin datos de temperatura",
                    style: textTheme.headline5?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // const SizedBox(height: Consts.defaultPadding / 2),
                ],
              ),
            );
          }

          // return SizedBox.shrink();
          return SizedBox(
            height: 300,
            child: charts.TimeSeriesChart(
              state.stats
                  .map(
                    (e) => charts.Series<TemperatureStat, DateTime>(
                      id: 'temperature/' + fridgeId,
                      data: state.stats,
                      domainFn: (temp, _) => temp.timestamp,
                      measureFn: (temp, _) => temp.temp,
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
