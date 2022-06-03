import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/models/temperature_parameters.dart';
import 'package:wifi_led_esp8266/ui/local/cubit/fridge_state_cubit.dart';
import 'package:wifi_led_esp8266/ui/local/cubit/temperature_parameter_cubit.dart';

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
        return BlocBuilder<TemperatureParameterCubit, TemperatureParameter>(
          builder: (context, temperatureParameter) {
            final initialTemperatureParameter =
                TemperatureParameter.initialFromFridgeState(fridgeState);

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Consts.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed:
                          temperatureParameter == initialTemperatureParameter
                              ? null
                              : () {
                                  context
                                      .read<TemperatureParameterCubit>()
                                      .set(fridgeState!);
                                },
                      child: const Text("Deshacer cambios"),
                    ),
                  ),
                  const SizedBox(height: Consts.defaultPadding),
                  const MinTemperatureController(),
                  const MaxTemperatureController(),
                ],
              ),
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
              Row(
                children: [
                  const Text(
                    "Temperatura mínima",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: temperatureParameter.minTemperature ==
                            fridgeState?.minTemperature
                        ? null
                        : () => context
                            .read<FridgeStateCubit>()
                            .setMinTemperature(
                                temperatureParameter.minTemperature),
                    child: const Text("Guardar"),
                  ),
                ],
              ),
              const SizedBox(height: Consts.defaultPadding / 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    temperatureParameter.minTemperature.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      min: -20,
                      max: temperatureParameter.maxTemperature - 1,
                      value: temperatureParameter.minTemperature.toDouble(),
                      onChanged: (value) => context
                          .read<TemperatureParameterCubit>()
                          .onChangedMinTemperature(value.toInt()),
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
              Row(
                children: [
                  const Text(
                    "Temperatura máxima",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: temperatureParameter.maxTemperature ==
                            fridgeState?.maxTemperature
                        ? null
                        : () => context
                            .read<FridgeStateCubit>()
                            .setMaxTemperature(
                                temperatureParameter.maxTemperature),
                    child: const Text("Guardar"),
                  ),
                ],
              ),
              const SizedBox(height: Consts.defaultPadding / 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    temperatureParameter.maxTemperature.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      min: temperatureParameter.minTemperature + 1,
                      max: 30,
                      value: temperatureParameter.maxTemperature.toDouble(),
                      onChanged: (value) => context
                          .read<TemperatureParameterCubit>()
                          .onChangedMaxTemperature(value.toInt()),
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
