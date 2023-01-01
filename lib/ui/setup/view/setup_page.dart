import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/coordinator_configuration.dart';
import 'package:wifi_led_esp8266/models/controller_configuration.dart';
import 'package:wifi_led_esp8266/theme.dart';
import 'package:wifi_led_esp8266/ui/local/bloc/connection_bloc.dart';
import 'package:wifi_led_esp8266/ui/local/local.dart';
import 'package:wifi_led_esp8266/ui/setup/cubit/coordinator_configuration_cubit.dart';
import 'package:wifi_led_esp8266/ui/setup/cubit/device_configuration_cubit.dart';
import 'package:wifi_led_esp8266/ui/setup/widgets/setup_appbar.dart';
import 'package:wifi_led_esp8266/utils/validators.dart';
import 'package:wifi_led_esp8266/widgets/widgets.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    return BlocProvider(
      create: (context) => LocalConnectionBloc(
        context.read(),
        context.read(),
      )..add(LocalConnectionInit()),
      lazy: false,
      child: const SetupView(),
    );
  }
}

class SetupView extends StatelessWidget {
  const SetupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Consts.lightSystem.shade300,
      appBar: const PreferredSize(
        child: SetupAppBar(),
        preferredSize: Size.fromHeight(70),
      ),
      body: SafeArea(
        child: BlocBuilder<LocalConnectionBloc, LocalConnectionState>(
          builder: (context, state) {
            if (state is LocalConnectionLoading) {
              return const Center(
                child: LoadingMessage(),
              );
            }
            if (state is LocalConnectionWaiting) {
              return const Center(
                child: LoadingMessage(),
              );
            }

            if (state is LocalConnectionDisconnected) {
              return const DisconnectedView();
            }

            if (state.connectionInfo == null) {
              return const NoDeviceFound();
            }

            if (!state.connectionInfo!.configurationMode) {
              return const NoConfigurationMode();
            }

            if (state.connectionInfo!.standalone) {
              return const SetupDeviceController();
            }
            return const SetupDeviceCoordinator();
          },
        ),
      ),
    );
  }
}

class NoConfigurationMode extends StatelessWidget {
  const NoConfigurationMode({Key? key}) : super(key: key);

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
              '''Estas intentando configurar un dispositivo que no esta en modo configuración. Asegurate que tu dispositivo este en modo configuración.''',
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

class NoDeviceFound extends StatelessWidget {
  const NoDeviceFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Consts.defaultPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/disconnected.jpg'),
            const SizedBox(height: Consts.defaultPadding / 2),
            Text(
              "No se encontró una conexión",
              style: textTheme.headline5?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            Text(
              "Asegurate de que estes conectado a la red correcta.",
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Consts.defaultPadding * 2),
            IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      context
                          .read<LocalConnectionBloc>()
                          .add(LocalConnectionConnect());
                    },
                    child: const Text(
                      "Conectarse",
                    ),
                  ),
                  const SizedBox(height: Consts.defaultPadding / 2),
                  const SizedBox(width: Consts.defaultPadding * 15),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    child: Text(
                      "Regresar",
                      style: textTheme.button?.copyWith(
                        color: Consts.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SetupDeviceController extends StatefulWidget {
  const SetupDeviceController({Key? key}) : super(key: key);

  @override
  State<SetupDeviceController> createState() => _SetupDeviceControllerState();
}

class _SetupDeviceControllerState extends State<SetupDeviceController> {
  final _formKeyFridge = GlobalKey<FormState>();
  final _formKeyCoordinator = GlobalKey<FormState>();
  final _formKeyInternet = GlobalKey<FormState>();
  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController ssidController = TextEditingController();
  late final TextEditingController ssidCoordinatorController =
      TextEditingController();
  late final TextEditingController ssidInternetController =
      TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  late final TextEditingController passwordCoordinatorController =
      TextEditingController();
  late final TextEditingController passwordInternetController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => DeviceConfigurationCubit(context.read()),
      child: BlocConsumer<DeviceConfigurationCubit, ControllerConfiguration>(
        listener: (context, deviceConfiguration) {
          // ssidController.text = deviceConfiguration.ssid;
          // ssidCoordinatorController.text = deviceConfiguration.ssidCoordinator;
          // ssidInternetController.text = deviceConfiguration.ssidInternet;
          // passwordController.text = deviceConfiguration.password;
          // passwordCoordinatorController.text =
          //     deviceConfiguration.passwordCoordinator;
          // passwordInternetController.text =
          //     deviceConfiguration.passwordInternet;
        },
        builder: (context, deviceConfiguration) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Consts.defaultPadding,
                vertical: Consts.defaultPadding,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Controlador de Nevera",
                              style: textTheme.headline5,
                            ),
                          ),
                          // Center(
                          //   child: Text(
                          //     context
                          //             .read<LocalConnectionBloc>()
                          //             .state
                          //             .connectionInfo
                          //             ?.id ??
                          //         '',
                          //   ),
                          // ),
                          /// Desired Temperature
                          const SizedBox(height: Consts.defaultPadding / 2),
                          const Text(
                            "Temperatura ideal",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: Consts.defaultPadding / 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                deviceConfiguration.desiredTemperature
                                    .toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                              Expanded(
                                child: Slider(
                                  min: -20,
                                  max: 30,
                                  value: deviceConfiguration.desiredTemperature
                                      .toDouble(),
                                  onChanged: (value) => context
                                      .read<DeviceConfigurationCubit>()
                                      .onChangedDesiredTemperature(
                                          value.toInt()),
                                ),
                              ),
                            ],
                          ),

                          /// Min Temperature
                          const SizedBox(height: Consts.defaultPadding),
                          const Text(
                            "Temperatura mínima",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: Consts.defaultPadding / 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                deviceConfiguration.minTemperature.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                              Expanded(
                                child: Slider(
                                  min: -20,
                                  max: deviceConfiguration.maxTemperature - 1,
                                  value: deviceConfiguration.minTemperature
                                      .toDouble(),
                                  onChanged: (value) => context
                                      .read<DeviceConfigurationCubit>()
                                      .onChangedMinTemperature(value.toInt()),
                                ),
                              ),
                            ],
                          ),

                          /// Max Temperature
                          const SizedBox(height: Consts.defaultPadding / 2),
                          const Text(
                            "Temperatura máxima",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: Consts.defaultPadding / 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                deviceConfiguration.maxTemperature.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                              Expanded(
                                child: Slider(
                                  min: deviceConfiguration.minTemperature + 1,
                                  max: 30,
                                  value: deviceConfiguration.maxTemperature
                                      .toDouble(),
                                  onChanged: (value) => context
                                      .read<DeviceConfigurationCubit>()
                                      .onChangedMaxTemperature(value.toInt()),
                                ),
                              ),
                            ],
                          ),

                          /// Start on which communication mode
                          const SizedBox(height: Consts.defaultPadding),
                          Row(
                            children: [
                              const Text(
                                "Modo coordinado",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              const Spacer(),
                              CupertinoSwitch(
                                value:
                                    deviceConfiguration.startOnCoordinatorMode,
                                activeColor: Consts.primary,
                                onChanged: (value) {
                                  setState(() {});
                                  context
                                      .read<DeviceConfigurationCubit>()
                                      .onChangeCommunicationModeStart(value);
                                },
                              )
                            ],
                          ),

                          /// Fridge Wifi
                          Form(
                            key: _formKeyFridge,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: Consts.defaultPadding),
                                const Center(
                                  child: Text(
                                    "Datos de la nevera",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(
                                  height: Consts.defaultPadding / 2,
                                ),
                                const Text(
                                  'Nombre del equipo',
                                  style: TextStyle(
                                    color: Consts.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                  height: Consts.defaultPadding / 2,
                                ),
                                TextFormField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    // border: OutlineInputBorder(),
                                    hintText:
                                        'Nombre para identificar al equipo',
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                    context
                                        .read<DeviceConfigurationCubit>()
                                        .onChangedName(value);
                                  },
                                  validator: Validators.validateEmpty,
                                  autovalidateMode: AutovalidateMode.always,
                                ),
                                const SizedBox(
                                  height: Consts.defaultPadding / 2,
                                ),
                                const Text(
                                  'SSDI de la nevera',
                                  style: TextStyle(
                                    color: Consts.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                  height: Consts.defaultPadding / 2,
                                ),
                                TextFormField(
                                  controller: ssidController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    // border: OutlineInputBorder(),
                                    hintText: 'SSDI de la nevera',
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                    context
                                        .read<DeviceConfigurationCubit>()
                                        .onChangedSsid(value);
                                  },
                                  validator: Validators.validateEmpty,
                                  autovalidateMode: AutovalidateMode.always,
                                ),
                                const SizedBox(
                                    height: Consts.defaultPadding / 2),
                                const Text(
                                  'Contraseña del Wifi',
                                  style: TextStyle(
                                    color: Consts.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                    height: Consts.defaultPadding / 2),
                                TextFormField(
                                  controller: passwordController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    // border: OutlineInputBorder(),
                                    hintText: 'Contraseña del Wifi',
                                  ),
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    setState(() {});
                                    context
                                        .read<DeviceConfigurationCubit>()
                                        .onChangedPassword(value);
                                  },
                                  validator: Validators.validatePassword,
                                  autovalidateMode: AutovalidateMode.always,
                                ),
                              ],
                            ),
                          ),

                          if (deviceConfiguration.startOnCoordinatorMode)
                            Form(
                              key: _formKeyCoordinator,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Coordinador Wifi
                                  const SizedBox(height: Consts.defaultPadding),
                                  const Center(
                                    child: Text(
                                      "WiFi del Coordinador",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: Consts.defaultPadding / 2),
                                  const Text(
                                    'SSDI del Coordinador',
                                    style: TextStyle(
                                      color: Consts.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.0,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                      height: Consts.defaultPadding / 2),
                                  TextFormField(
                                    controller: ssidCoordinatorController,
                                    decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      // border: OutlineInputBorder(),
                                      hintText: 'SSDI del Coordinador',
                                    ),
                                    onChanged: (value) {
                                      setState(() {});
                                      context
                                          .read<DeviceConfigurationCubit>()
                                          .onChangedSsidCoordinator(value);
                                    },
                                    validator: Validators.validateEmpty,
                                    autovalidateMode: AutovalidateMode.always,
                                  ),
                                  const SizedBox(
                                      height: Consts.defaultPadding / 2),
                                  const Text(
                                    'Contraseña del Coordinador',
                                    style: TextStyle(
                                      color: Consts.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.0,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                      height: Consts.defaultPadding / 2),
                                  TextFormField(
                                    controller: passwordCoordinatorController,
                                    decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      // border: OutlineInputBorder(),
                                      hintText:
                                          'Contraseña del Wifi del Coordinador',
                                    ),
                                    obscureText: true,
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      setState(() {});
                                      context
                                          .read<DeviceConfigurationCubit>()
                                          .onChangedPasswordCordinator(value);
                                    },
                                    validator: Validators.validatePassword,
                                    autovalidateMode: AutovalidateMode.always,
                                  ),
                                ],
                              ),
                            ),
                          Form(
                            key: _formKeyInternet,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: Consts.defaultPadding),
                                const Center(
                                  child: Text(
                                    "WiFi de Internet",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(
                                    height: Consts.defaultPadding / 2),
                                const Text(
                                  'SSDI del Wifi (Internet)',
                                  style: TextStyle(
                                    color: Consts.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                    height: Consts.defaultPadding / 2),
                                TextFormField(
                                  controller: ssidInternetController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    // border: OutlineInputBorder(),
                                    hintText:
                                        'Ingrese el nombre del WiFi con internet',
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                    context
                                        .read<DeviceConfigurationCubit>()
                                        .onChangedSsidInternet(value);
                                  },
                                  validator: Validators.validateEmpty,
                                  autovalidateMode: AutovalidateMode.always,
                                ),
                                const SizedBox(
                                    height: Consts.defaultPadding / 2),
                                const Text(
                                  'Contraseña del Wifi',
                                  style: TextStyle(
                                    color: Consts.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                    height: Consts.defaultPadding / 2),
                                TextFormField(
                                  controller: passwordInternetController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    // border: OutlineInputBorder(),
                                    hintText: 'Contraseña del Wifi',
                                  ),
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    setState(() {});
                                    context
                                        .read<DeviceConfigurationCubit>()
                                        .onChangedPasswordInternet(value);
                                  },
                                  validator: Validators.validatePassword,
                                  autovalidateMode: AutovalidateMode.always,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: Consts.defaultPadding * 2),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Consts.defaultPadding),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Consts.primary.shade300,
                      shape: CustomTheme.buttonShape,
                      minimumSize: const Size.fromHeight(40), // NEW
                    ),
                    onPressed: finalize(context, deviceConfiguration),
                    child: Text(
                      "FINALIZAR",
                      style: textTheme.button?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Function()? finalize(
      BuildContext context, ControllerConfiguration deviceConfiguration) {
    if (!deviceConfiguration.startOnCoordinatorMode) {
      if (_formKeyFridge.currentState == null ||
          _formKeyInternet.currentState == null) return null;

      if (!_formKeyFridge.currentState!.validate() ||
          !_formKeyInternet.currentState!.validate()) return null;
    } else {
      if (_formKeyFridge.currentState == null ||
          _formKeyCoordinator.currentState == null ||
          _formKeyInternet.currentState == null) return null;

      if (!_formKeyFridge.currentState!.validate() ||
          !_formKeyCoordinator.currentState!.validate() ||
          !_formKeyInternet.currentState!.validate()) return null;
    }

    return () async {
      // _formKeyFridge.currentState!.validate();
      // _formKeyCoordinator.currentState!.validate();
      // _formKeyInternet.currentState!.validate();
      await futureLoadingIndicator<bool>(
              context,
              context
                  .read<DeviceConfigurationCubit>()
                  .configureController(deviceConfiguration))
          .then((value) {
        if (value == null) return;
        if (value) {
          Navigator.maybePop(context);
        }
      });
    };
  }
}

class SetupDeviceCoordinator extends StatefulWidget {
  const SetupDeviceCoordinator({Key? key}) : super(key: key);

  @override
  State<SetupDeviceCoordinator> createState() => _SetupDeviceCoordinatorState();
}

class _SetupDeviceCoordinatorState extends State<SetupDeviceCoordinator> {
  final _formKeyCoordinator = GlobalKey<FormState>();
  final _formKeyInternet = GlobalKey<FormState>();
  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController ssidController = TextEditingController();
  late final TextEditingController ssidCoordinatorController =
      TextEditingController();
  late final TextEditingController ssidInternetController =
      TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  late final TextEditingController passwordCoordinatorController =
      TextEditingController();
  late final TextEditingController passwordInternetController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => CoordinatorConfigurationCubit(context.read()),
      child:
          BlocConsumer<CoordinatorConfigurationCubit, CoordinatorConfiguration>(
        listener: (context, deviceConfiguration) {
          // ssidController.text = deviceConfiguration.ssid;
          // ssidCoordinatorController.text = deviceConfiguration.ssidCoordinator;
          // ssidInternetController.text = deviceConfiguration.ssidInternet;
          // passwordController.text = deviceConfiguration.password;
          // passwordCoordinatorController.text =
          //     deviceConfiguration.passwordCoordinator;
          // passwordInternetController.text =
          //     deviceConfiguration.passwordInternet;
        },
        builder: (context, deviceConfiguration) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Consts.defaultPadding,
                vertical: Consts.defaultPadding,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Coordinador de comunicaciones",
                              style: textTheme.headline2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Center(
                            child: Text(
                              context
                                      .read<LocalConnectionBloc>()
                                      .state
                                      .connectionInfo
                                      ?.id ??
                                  '',
                            ),
                          ),
                          Form(
                            key: _formKeyCoordinator,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Coordinador Wifi
                                const SizedBox(height: Consts.defaultPadding),
                                const Text(
                                  'Nombre del equipo',
                                  style: TextStyle(
                                    color: Consts.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                  height: Consts.defaultPadding / 2,
                                ),
                                TextFormField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    // border: OutlineInputBorder(),
                                    hintText:
                                        'Nombre para identificar al equipo',
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                    context
                                        .read<CoordinatorConfigurationCubit>()
                                        .onChangedName(value);
                                  },
                                  validator: Validators.validateEmpty,
                                  autovalidateMode: AutovalidateMode.always,
                                ),
                                const SizedBox(
                                  height: Consts.defaultPadding / 2,
                                ),
                                const Center(
                                  child: Text(
                                    "WiFi del Coordinador",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(
                                    height: Consts.defaultPadding / 2),
                                const Text(
                                  'SSDI del Coordinador',
                                  style: TextStyle(
                                    color: Consts.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                    height: Consts.defaultPadding / 2),
                                TextFormField(
                                  controller: ssidCoordinatorController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    // border: OutlineInputBorder(),
                                    hintText: 'SSDI del Coordinador',
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                    context
                                        .read<CoordinatorConfigurationCubit>()
                                        .onChangedSsid(value);
                                  },
                                  validator: Validators.validateEmpty,
                                  autovalidateMode: AutovalidateMode.always,
                                ),
                                const SizedBox(
                                    height: Consts.defaultPadding / 2),
                                const Text(
                                  'Contraseña del Coordinador',
                                  style: TextStyle(
                                    color: Consts.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                    height: Consts.defaultPadding / 2),
                                TextFormField(
                                  controller: passwordCoordinatorController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    // border: OutlineInputBorder(),
                                    hintText:
                                        'Contraseña del Wifi del Coordinador',
                                  ),
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    setState(() {});
                                    context
                                        .read<CoordinatorConfigurationCubit>()
                                        .onChangedPassword(value);
                                  },
                                  validator: Validators.validatePassword,
                                  autovalidateMode: AutovalidateMode.always,
                                ),
                              ],
                            ),
                          ),
                          Form(
                            key: _formKeyInternet,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: Consts.defaultPadding),
                                const Center(
                                  child: Text(
                                    "WiFi de Internet",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(
                                    height: Consts.defaultPadding / 2),
                                const Text(
                                  'SSDI del Wifi (Internet)',
                                  style: TextStyle(
                                    color: Consts.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                    height: Consts.defaultPadding / 2),
                                TextFormField(
                                  controller: ssidInternetController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    // border: OutlineInputBorder(),
                                    hintText:
                                        'Ingrese el nombre del WiFi con internet',
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                    context
                                        .read<CoordinatorConfigurationCubit>()
                                        .onChangedSsidInternet(value);
                                  },
                                  validator: Validators.validateEmpty,
                                  autovalidateMode: AutovalidateMode.always,
                                ),
                                const SizedBox(
                                    height: Consts.defaultPadding / 2),
                                const Text(
                                  'Contraseña del Wifi',
                                  style: TextStyle(
                                    color: Consts.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                    height: Consts.defaultPadding / 2),
                                TextFormField(
                                  controller: passwordInternetController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    // border: OutlineInputBorder(),
                                    hintText: 'Contraseña del Wifi',
                                  ),
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    setState(() {});
                                    context
                                        .read<CoordinatorConfigurationCubit>()
                                        .onChangedPasswordInternet(value);
                                  },
                                  validator: Validators.validatePassword,
                                  autovalidateMode: AutovalidateMode.always,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: Consts.defaultPadding * 2),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Consts.defaultPadding),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Consts.primary.shade600,
                      shape: CustomTheme.buttonShape,
                      minimumSize: const Size.fromHeight(40), // NEW
                    ),
                    onPressed: finalize(context, deviceConfiguration),
                    child: Text(
                      "FINALIZAR",
                      style: textTheme.button?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Function()? finalize(
      BuildContext context, CoordinatorConfiguration coordinatorConfiguration) {
    if (_formKeyCoordinator.currentState == null ||
        _formKeyInternet.currentState == null) return null;

    if (!_formKeyCoordinator.currentState!.validate() ||
        !_formKeyInternet.currentState!.validate()) return null;

    return () async {
      // _formKeyFridge.currentState!.validate();
      // _formKeyCoordinator.currentState!.validate();
      // _formKeyInternet.currentState!.validate();
      await futureLoadingIndicator(
              context,
              context
                  .read<CoordinatorConfigurationCubit>()
                  .configureCoordinator(coordinatorConfiguration))
          .then((value) {
        Navigator.maybePop(context);
      });
    };
  }
}
