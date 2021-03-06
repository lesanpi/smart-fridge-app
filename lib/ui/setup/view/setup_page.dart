import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/coordinator_configuration.dart';
import 'package:wifi_led_esp8266/models/device_configuration.dart';
import 'package:wifi_led_esp8266/models/models.dart';
import 'package:wifi_led_esp8266/theme.dart';
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
      create: (context) => ConnectionCubit(
        context.read(),
        context.read(),
      )..init(),
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
      backgroundColor: Consts.lightSystem.shade300,
      appBar: const PreferredSize(
        child: SetupAppBar(),
        preferredSize: Size.fromHeight(50),
      ),
      body: SafeArea(
        child: BlocBuilder<ConnectionCubit, ConnectionInfo?>(
          builder: (context, connectionInfo) {
            if (connectionInfo == null) {
              return const NoDeviceFound();
            }

            if (!connectionInfo.configurationMode) {
              return const NoConfigurationMode();
            }

            if (connectionInfo.standalone) {
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
            const Text(
              "Atenci??n!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            Text(
              '''Estas intentando configurar un dispositivo que no esta en modo configuraci??n. Asegurate que tu dispositivo este en modo configuraci??n.''',
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
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
            const Icon(
              Icons.disabled_visible_rounded,
              size: 100,
              color: Consts.primary,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            const Text(
              "No se encontro una conexi??n",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Colors.black38,
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
                      await context.read<ConnectionCubit>().connect('');
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
                    child: const Text("Regresar"),
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
      child: BlocConsumer<DeviceConfigurationCubit, DeviceConfiguration>(
        listener: (context, deviceConfiguration) {
          print('cambio');
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
                              style: textTheme.headline2,
                            ),
                          ),
                          Center(
                            child: Text(
                              context.read<ConnectionCubit>().state?.id ?? '',
                            ),
                          ),

                          /// Min Temperature
                          const SizedBox(height: Consts.defaultPadding),
                          const Text(
                            "Temperatura m??nima",
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
                            "Temperatura m??xima",
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
                                  'Contrase??a del Wifi',
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
                                    hintText: 'Contrase??a del Wifi',
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
                                    'Contrase??a del Coordinador',
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
                                          'Contrase??a del Wifi del Coordinador',
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
                                  'Contrase??a del Wifi',
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
                                    hintText: 'Contrase??a del Wifi',
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
                      primary: Consts.primary.shade600,
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
      BuildContext context, DeviceConfiguration deviceConfiguration) {
    if (!deviceConfiguration.startOnCoordinatorMode) {
      print('no empezar en modo coordinado');
      print(_formKeyFridge.currentState);
      print(_formKeyInternet.currentState);
      if (_formKeyFridge.currentState == null ||
          _formKeyInternet.currentState == null) return null;

      if (!_formKeyFridge.currentState!.validate() ||
          !_formKeyInternet.currentState!.validate()) return null;
    } else {
      print('empezar en coordinado');
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
      await futureLoadingIndicator(
              context,
              context
                  .read<DeviceConfigurationCubit>()
                  .configureController(deviceConfiguration))
          .then((value) {
        Navigator.maybePop(context);
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
          print('cambio');
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
                              context.read<ConnectionCubit>().state?.id ?? '',
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
                                  'Contrase??a del Coordinador',
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
                                        'Contrase??a del Wifi del Coordinador',
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
                                  'Contrase??a del Wifi',
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
                                    hintText: 'Contrase??a del Wifi',
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
                      primary: Consts.primary.shade600,
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
    print('empezar en coordinado');
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
