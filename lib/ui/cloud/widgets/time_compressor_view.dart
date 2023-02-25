import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:wifi_led_esp8266/models/models.dart';
import 'package:wifi_led_esp8266/ui/cloud/cubit/compressor_time_cubit.dart';
import 'package:wifi_led_esp8266/ui/cloud/cubit/fridge_state_cubit.dart';

import '../../../consts.dart';

class TimeCompressorView extends StatelessWidget {
  const TimeCompressorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompressorTimeCubit(
        context.read<FridgeStateCubit>().state!.compresorMinutesToWait,
      ),
      child: const FridgeCompressorTimeBody(),
    );
  }
}

class FridgeCompressorTimeBody extends StatelessWidget {
  const FridgeCompressorTimeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FridgeStateCubit, FridgeState?>(
        builder: (context, fridgeState) {
      return BlocBuilder<CompressorTimeCubit, int>(
        builder: (context, minutes) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: Consts.defaultPadding),
              Row(
                children: const [
                  Icon(Icons.timelapse_sharp),
                  SizedBox(width: Consts.defaultPadding / 2),
                  Text(
                    "Intervalo del compresor",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              const Text(
                'El compresor necesita reposar apagado un intervalo de tiempo antes de encenderse nuevamente. ¡Pero tu lo puedes configurar! ¿Cuantos minutos deseas?',
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: Consts.defaultPadding),
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
                            '${percentage.toInt()} min.',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onChange: (value) => context
                      .read<CompressorTimeCubit>()
                      .onChangedMinutes(value.toInt()),
                  min: 1,
                  max: 20,
                  initialValue: minutes.toDouble(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: minutes == fridgeState?.compresorMinutesToWait
                          ? null
                          : () => context
                              .read<CompressorTimeCubit>()
                              .onChangedMinutes(
                                  fridgeState!.compresorMinutesToWait),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                        foregroundColor: Consts.primary,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text('Deshacer '),
                    ),
                  ),
                  const SizedBox(
                    width: Consts.defaultPadding / 2,
                  ),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: minutes == fridgeState?.compresorMinutesToWait
                          ? null
                          : () => context
                              .read<FridgeStateCubit>()
                              .setMinutesToWait(minutes),
                      child: const Text("Guardar cambios"),
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
