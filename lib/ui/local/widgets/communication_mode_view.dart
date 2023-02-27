import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/communication_mode.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/ui/local/cubit/fridge_state_cubit.dart';
import 'package:wifi_led_esp8266/widgets/future_loading_indicator.dart';

import '../cubit/communication_mode_cubit.dart';

class CommunicationModeView extends StatelessWidget {
  const CommunicationModeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommunicationModeCubit(
        CommunicationMode.fromFridgeState(
          context.read<FridgeStateCubit>().state,
        ),
      ),
      child: BlocBuilder<FridgeStateCubit, FridgeState?>(
          builder: (context, fridgeState) {
        return BlocBuilder<CommunicationModeCubit, CommunicationMode>(
            builder: (context, communicationMode) {
          final initialCommunicationMode =
              CommunicationMode.fromFridgeState(fridgeState);

          return Column(
            children: [
              // const SizedBox(height: Consts.defaultPadding),
              if (communicationMode.coordinatorMode)
                CoordinatorCommunicationView(
                  communicationMode: communicationMode,
                  initialCommunicationMode: initialCommunicationMode,
                )
              else
                StandaloneCommunicationView(
                  communicationMode: communicationMode,
                  initialCommunicationMode: initialCommunicationMode,
                ),
            ],
          );
        });
      }),
    );
  }
}

class StandaloneCommunicationView extends StatefulWidget {
  const StandaloneCommunicationView({
    Key? key,
    required this.communicationMode,
    required this.initialCommunicationMode,
  }) : super(key: key);
  final CommunicationMode communicationMode;
  final CommunicationMode initialCommunicationMode;

  @override
  State<StandaloneCommunicationView> createState() =>
      _StandaloneCommunicationViewState();
}

class _StandaloneCommunicationViewState
    extends State<StandaloneCommunicationView> {
  late final TextEditingController ssidController =
      TextEditingController(text: widget.communicationMode.ssid);
  late final TextEditingController ssidPassword =
      TextEditingController(text: widget.communicationMode.password);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunicationModeCubit, CommunicationMode>(
      builder: (context, communicationMode) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "💾 Datos de la nevera",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 27,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: Consts.defaultPadding / 2,
            ),
            const Text(
              'Indica las credenciales de la red WiFi de emergencia. Esta red WiFi se activara ante cualquier falla, ¡Así siempre estaras comunicado! Pero también asegurate tener una contraseña segura y que recuerdes para estos momentos de emergencia.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: Consts.defaultPadding),
            const Text(
              'SSDI de la nevera',
              style: TextStyle(
                color: Consts.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            TextField(
              controller: ssidController,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                // border: OutlineInputBorder(),
                hintText: 'SSDI de la nevera',
              ),
              onChanged: context.read<CommunicationModeCubit>().onChangedSsid,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            const Text(
              'Contraseña del Wifi',
              style: TextStyle(
                color: Consts.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            TextField(
              // controller: newPasswordController,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                // border: OutlineInputBorder(),
                hintText: 'Contraseña del Wifi',
              ),
              obscureText: true,
              keyboardType: TextInputType.text,
              onChanged:
                  context.read<CommunicationModeCubit>().onChangedPassword,
            ),
            const SizedBox(height: Consts.defaultPadding),
            Center(
              child: BlocBuilder<FridgeStateCubit, FridgeState?>(
                builder: (context, fridgeState) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: BlocBuilder<CommunicationModeCubit,
                            CommunicationMode>(
                          builder: (context, communicationMode) {
                            final initialCommunicationMode =
                                CommunicationMode.fromFridgeState(fridgeState);
                            return ElevatedButton(
                              onPressed:
                                  communicationMode == initialCommunicationMode
                                      ? null
                                      : () {
                                          context
                                              .read<CommunicationModeCubit>()
                                              .set(fridgeState!);
                                        },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                disabledBackgroundColor: Colors.transparent,
                                foregroundColor: Consts.primary,
                                shadowColor: Colors.transparent,
                              ),
                              child: const Text("Deshacer"),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: Consts.defaultPadding / 2,
                      ),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: widget.communicationMode ==
                                  widget.initialCommunicationMode
                              ? null
                              : () => onDialogMessage(
                                    context: context,
                                    title: '¡Advertencia!',
                                    message:
                                        'Realizar este cambio lo desconectara de la red Wifi, intente volver a conectarse después de unos segundos',
                                    warning: true,
                                    warningButtonText: 'EJECUTAR',
                                    warningCallback: () => context
                                        .read<FridgeStateCubit>()
                                        .setStandaloneMode(communicationMode),
                                  ),
                          child: const Center(
                              child: Text(
                            "Cambiar Modo Independiente",
                            textAlign: TextAlign.center,
                          )),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class CoordinatorCommunicationView extends StatefulWidget {
  const CoordinatorCommunicationView({
    Key? key,
    required this.communicationMode,
    required this.initialCommunicationMode,
  }) : super(key: key);
  final CommunicationMode communicationMode;
  final CommunicationMode initialCommunicationMode;

  @override
  State<CoordinatorCommunicationView> createState() =>
      _CoordinatorCommunicationViewState();
}

class _CoordinatorCommunicationViewState
    extends State<CoordinatorCommunicationView> {
  late final TextEditingController ssidCoordinatorController =
      TextEditingController(text: widget.communicationMode.ssidCoordinator);
  late final TextEditingController ssidPasswordCoordinator =
      TextEditingController(text: widget.communicationMode.passwordCoordinator);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunicationModeCubit, CommunicationMode>(
      builder: (context, communicationMode) {
        return Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Consts.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SSDI del Coordinador',
                style: TextStyle(
                  color: Consts.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: Consts.defaultPadding / 2),
              TextField(
                controller: ssidCoordinatorController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  // border: OutlineInputBorder(),
                  hintText: 'SSDI del Coordinador',
                ),
                onChanged: context
                    .read<CommunicationModeCubit>()
                    .onChangedSsidCoordinator,
              ),
              const SizedBox(height: Consts.defaultPadding / 2),
              const Text(
                'Contraseña del Coordinador',
                style: TextStyle(
                  color: Consts.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: Consts.defaultPadding / 2),
              TextField(
                controller: ssidPasswordCoordinator,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  // border: OutlineInputBorder(),

                  hintText: 'Contraseña del Coordinador',
                ),
                obscureText: true,
                onChanged: context
                    .read<CommunicationModeCubit>()
                    .onChangedPasswordCoordinator,
              ),
              const SizedBox(height: Consts.defaultPadding),
              Center(
                child: ElevatedButton(
                  onPressed: widget.communicationMode ==
                          widget.initialCommunicationMode
                      ? null
                      : () => onDialogMessage(
                            context: context,
                            title: '¡Advertencia!',
                            message:
                                'Realizar este cambio lo desconectara de la red Wifi, intente volver a conectarse después de unos segundos',
                            warning: true,
                            warningButtonText: 'EJECUTAR',
                            warningCallback: () => context
                                .read<FridgeStateCubit>()
                                .setCoordinatorMode(communicationMode),
                          ),
                  child: const Text("Cambiar Modo Coordinado"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
