import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/models/temperature_parameters.dart';
import 'package:wifi_led_esp8266/ui/cloud/cubit/fridge_state_cubit.dart';
import 'package:wifi_led_esp8266/ui/cloud/cubit/temperature_parameter_cubit.dart';

class TemperatureParameterView extends StatelessWidget {
  const TemperatureParameterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TemperatureParameterCubit(
          TemperatureParameter.initialFromFridgeState(
              context.read<FridgeStateCubit>().state)),
      child: BlocBuilder<FridgeStateCubit, FridgeState?>(
          builder: (context, fridgeState) {
        if (fridgeState == null) return const SizedBox.shrink();

        return BlocConsumer<TemperatureParameterCubit, TemperatureParameter>(
          listener: (context, temperatureParameter) {
            final initialTemperatureParameter =
                TemperatureParameter.initialFromFridgeState(fridgeState);

            if (temperatureParameter != initialTemperatureParameter) {
              // context.read<TemperatureParameterCubit>().set(fridgeState!);
            }
          },
          builder: (context, temperatureParameter) {
            final initialTemperatureParameter =
                TemperatureParameter.initialFromFridgeState(fridgeState);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const DesiredTemperatureController(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Expanded(child: MinTemperatureController()),
                    SizedBox(
                      width: Consts.defaultPadding / 2,
                    ),
                    Expanded(child: MaxTemperatureController()),
                  ],
                ),
                const SizedBox(height: Consts.defaultPadding),
                Center(
                  child: ElevatedButton(
                    onPressed:
                        temperatureParameter == initialTemperatureParameter
                            ? null
                            : () {
                                context
                                    .read<TemperatureParameterCubit>()
                                    .set(fridgeState);
                              },
                    child: const Center(child: Text("Deshacer cambios")),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}

class MinTemperatureController extends StatelessWidget {
  const MinTemperatureController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FridgeStateCubit, FridgeState?>(
        builder: (context, fridgeState) {
      return BlocBuilder<TemperatureParameterCubit, TemperatureParameter>(
        builder: (context, temperatureParameter) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: Consts.defaultPadding),
              const Text(
                "📉 Temp.\n mínima",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                // textAlign: TextAlign.start,
              ),
              const SizedBox(height: Consts.defaultPadding / 2),
              const Text(
                '¿A que valor de temperatura mínima te gustaria recibir una alerta?',
              ),
              const SizedBox(height: Consts.defaultPadding / 2),
              Center(
                child: SleekCircularSlider(
                  appearance: CircularSliderAppearance(
                    customColors: CustomSliderColors(
                      progressBarColor: Colors.blue.shade200,
                      shadowColor: Colors.blue.shade200,
                      trackColor: Colors.blue.shade200,
                    ),
                    customWidths: CustomSliderWidths(progressBarWidth: 10),
                  ),
                  innerWidget: (percentage) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${percentage.toInt()} °C',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          const Text('Temp.'),
                        ],
                      ),
                    );
                  },
                  onChange: (value) => context
                      .read<TemperatureParameterCubit>()
                      .onChangedMinTemperature(value.toInt()),
                  min: -20,
                  max: temperatureParameter.maxTemperature - 1,
                  initialValue: temperatureParameter.minTemperature.toDouble(),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: temperatureParameter.minTemperature ==
                          fridgeState?.minTemperature
                      ? null
                      : () => context
                          .read<FridgeStateCubit>()
                          .setMinTemperature(
                              temperatureParameter.minTemperature),
                  child: const Text("Guardar"),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}

class MaxTemperatureController extends StatelessWidget {
  const MaxTemperatureController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FridgeStateCubit, FridgeState?>(
        builder: (context, fridgeState) {
      return BlocBuilder<TemperatureParameterCubit, TemperatureParameter>(
        builder: (context, temperatureParameter) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: Consts.defaultPadding),
              const Text(
                "📈 Temp. máxima",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: Consts.defaultPadding / 2),
              const Text(
                '¿A que valor de temperatura máxima te gustaria recibir una alerta?',
              ),
              const SizedBox(height: Consts.defaultPadding / 2),
              Center(
                child: SleekCircularSlider(
                  appearance: CircularSliderAppearance(
                    customColors: CustomSliderColors(
                      progressBarColor: Colors.blue.shade200,
                      shadowColor: Colors.blue.shade200,
                      trackColor: Colors.blue.shade200,
                    ),
                    customWidths: CustomSliderWidths(progressBarWidth: 10),
                  ),
                  innerWidget: (percentage) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${percentage.toInt()} °C',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          const Text('Temp.'),
                        ],
                      ),
                    );
                  },
                  onChange: (value) => context
                      .read<TemperatureParameterCubit>()
                      .onChangedMaxTemperature(value.toInt()),
                  min: temperatureParameter.minTemperature + 1,
                  max: 30,
                  initialValue: temperatureParameter.maxTemperature.toDouble(),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: temperatureParameter.maxTemperature ==
                          fridgeState?.maxTemperature
                      ? null
                      : () => context
                          .read<FridgeStateCubit>()
                          .setMaxTemperature(
                              temperatureParameter.maxTemperature),
                  child: const Text("Guardar"),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}

class DesiredTemperatureController extends StatelessWidget {
  const DesiredTemperatureController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FridgeStateCubit, FridgeState?>(
        builder: (context, fridgeState) {
      return BlocBuilder<TemperatureParameterCubit, TemperatureParameter>(
        builder: (context, temperatureParameter) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: Consts.defaultPadding),
              Row(
                children: [
                  const Text(
                    "Temperatura deseada",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: temperatureParameter.desiredTemperature ==
                            fridgeState?.desiredTemperature
                        ? null
                        : () => context
                            .read<FridgeStateCubit>()
                            .setDesiredTemperature(
                                temperatureParameter.desiredTemperature),
                    child: const Text("Guardar"),
                  ),
                ],
              ),
              const SizedBox(height: Consts.defaultPadding / 2),
              const Text(
                  'Indica el valor referencial de la temperatura que debería estar el equipo normalmente.'),
              const SizedBox(height: Consts.defaultPadding / 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 65,
                    child: Text(
                      '${temperatureParameter.desiredTemperature} °C',
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: Theme.of(context).sliderTheme.copyWith(
                            trackHeight: 40,
                          ),
                      child: Slider(
                        min: -20,
                        max: 30,
                        value:
                            temperatureParameter.desiredTemperature.toDouble(),
                        onChanged: (value) => context
                            .read<TemperatureParameterCubit>()
                            .onChangedDesiredTemperature(value.toInt()),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    });
  }
}
