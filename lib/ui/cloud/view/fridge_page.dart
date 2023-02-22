import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
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
            buildWhen: (previous, current) =>
                (previous == null && current != null) ||
                current == null && previous != null,
            builder: (context, fridge) {
              if (fridge == null) {
                return const NoDataView();
              }

              return BlocProvider(
                create: (context) =>
                    TemperatureStatsBloc(context.read(), fridge.id)
                      ..add(TemperatureStatsGet()),
                child: Center(
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
                          child: const FridgeThermostat(),
                        ),

                        const SizedBox(height: Consts.defaultPadding * 1),
                        const FridgeCompressor(),
                        const SizedBox(height: Consts.defaultPadding),
                        const FridgeBattery(),
                        const SizedBox(height: Consts.defaultPadding),
                        const FridgeExternalTemperature(),
                        const SizedBox(height: Consts.defaultPadding),

                        const FridgeLightElectricity(),

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
                ),
              );
            },
          ),
        ),
      ),
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
              'Temperatura Externa',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
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
          ],
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
          title: 'Compresor',
          onText: 'Encendido',
          offText: 'Apagado',
          output: fridge.compressor,
          color: Colors.lightBlue.shade200.withOpacity(0.3),
          icon: Icons.ac_unit,
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
            Text(
              'Batería de respaldo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.8),
              ),
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

class FridgeThermostat extends StatelessWidget {
  const FridgeThermostat({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FridgeStateCubit, FridgeState?>(
      builder: (context, fridge) {
        if (fridge == null) {
          return const NoDataView();
        }
        return Stack(
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
                    alert: !(fridge.temperature >= fridge.minTemperature &&
                        fridge.temperature <= fridge.maxTemperature),
                  ),
                ),
                const SizedBox(height: Consts.defaultPadding * 2),
                NameController(initialName: fridge.name),
                const SizedBox(height: Consts.defaultPadding * 2),
              ],
            ),
          ],
        );
      },
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
  FridgeStats({Key? key, required this.fridgeId}) : super(key: key);
  final String fridgeId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<TemperatureStatsBloc, TemperatureStatsState>(
      builder: (context, state) {
        if (state is TemperatureStatsLoading ||
            state is TemperatureStatsInitial) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: Consts.defaultPadding * 3),
            child: Center(child: LoadingMessage()),
          );
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
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                // const SizedBox(height: Consts.defaultPadding / 2),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: Consts.defaultPadding),
            AspectRatio(
              aspectRatio: 1,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  // color: Colors.blue.withOpacity(0.2),
                  // border: Border.all(color: Consts.fontDark),
                ),
                child: LineChart(
                  mainData(state.stats),
                ),
              ),
            ),
          ],
        );

        // return SizedBox.shrink();
        // return SizedBox(
        //   height: 300,
        //   child: charts.TimeSeriesChart(
        //     state.stats
        //         .map(
        //           (e) => charts.Series<TemperatureStat, DateTime>(
        //             id: 'temperature/' + fridgeId,
        //             data: state.stats,
        //             domainFn: (temp, _) => temp.timestamp,
        //             measureFn: (temp, _) => temp.temp,
        //           ),
        //         )
        //         .toList(),
        //   ),
        // );
      },
    );
  }

  LineChartData mainData(List<TemperatureStat> stats) {
    final spots = stats
        .asMap()
        .entries
        .map((e) => FlSpot(
                  e.key.toDouble(),
                  double.parse(e.value.temp.toStringAsFixed(3)),
                )
            // charts.Series<TemperatureStat, DateTime>(
            //   id: 'temperature/' + fridgeId,
            //   data: state.stats,
            //   domainFn: (temp, _) => temp.timestamp,
            //   measureFn: (temp, _) => temp.temp,
            // ),
            )
        .toList();
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 30,
            interval: 1,
            // getTitlesWidget: (value, meta) {
            //   return
            //   // final index = int.parse(value.toString());
            //   // final tempData = stats[index];
            //   // return Text(meta.)
            //   // return Text(value.toString());
            //   // return Text('${tempData.temp}');
            // },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            // getTitlesWidget: leftTitleWidgets,
            reservedSize: 45,
          ),
        ),
      ),
      borderData: FlBorderData(show: true, border: Border.all(width: 0)
          // border: Border.all(color: const Color(0xff37434d)),
          ),
      minX: 0,
      maxX: stats.length.toDouble(),
      minY: stats.map((e) => e.temp).toList().reduce(min).toInt() - 1,
      maxY: stats.map((e) => e.temp).toList().reduce(max).toInt() + 1,
      // maxY: 50,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueAccent,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;

              final date = stats[flSpot.x.toInt()].timestamp;
              TextAlign textAlign;
              switch (flSpot.x.toInt()) {
                case 1:
                  textAlign = TextAlign.left;
                  break;
                case 5:
                  textAlign = TextAlign.right;
                  break;
                default:
                  textAlign = TextAlign.center;
              }

              // final dateString = DateFormat..().format(date.toLocal());
              return LineTooltipItem(
                '${date.toLocal()}\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: flSpot.y.toString(),
                    style: TextStyle(
                      color: Colors.grey[100],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const TextSpan(
                    text: '°C',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
                textAlign: textAlign,
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  List<Color> gradientColors = [
    Consts.primary,
    const Color(0xff02d39a),
    Consts.primary.shade100,
  ];
}
