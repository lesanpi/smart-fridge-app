import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/data/repositories/bluetooth_repository.dart';
import 'package:wifi_led_esp8266/models/device_configuration.dart';
import 'package:wifi_led_esp8266/theme.dart';
import 'package:wifi_led_esp8266/ui/setup/cubit/device_configuration_cubit.dart';
import 'package:wifi_led_esp8266/ui/setup/cubit/discovering_cubit.dart';
import 'package:wifi_led_esp8266/ui/setup/cubit/enable_bluetooth_cubit.dart';
import 'package:wifi_led_esp8266/ui/setup/cubit/setup_device_cubit.dart';
import 'package:wifi_led_esp8266/ui/setup/widgets/setup_appbar.dart';
import 'package:wifi_led_esp8266/utils/validators.dart';
import 'package:wifi_led_esp8266/widgets/loading_indicator.dart';
import 'package:wifi_led_esp8266/widgets/widgets.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Consts.lightSystem.shade300,
      // backgroundColor: Consts.primary.shade600,
      appBar: const PreferredSize(
        child: SetupAppBar(),
        preferredSize: Size.fromHeight(50),
      ),
      body: SafeArea(
        child: FutureBuilder<bool?>(
            future: FlutterBluetoothSerial.instance.isEnabled,
            builder: (context, snapshotEnabled) {
              if (!snapshotEnabled.hasData) {
                return const NoDataView();
              }

              if (snapshotEnabled.data == null) {
                return const NoDataView();
              }

              return BlocProvider(
                create: (context) =>
                    EnableBluetoothCubit(snapshotEnabled.data!)..init(),
                child: const SetupView(),
              );
            }),
      ),
    );
  }
}

class SetupView extends StatelessWidget {
  const SetupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnableBluetoothCubit, bool>(builder: (context, enabled) {
      if (!enabled) {
        return const NoEnabledBluetooth();
      }

      return const PairedDevices();
    });
  }
}

class WaitingForChangeBluetooth extends StatelessWidget {
  const WaitingForChangeBluetooth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return StreamBuilder<BluetoothState>(
      stream: FlutterBluetoothSerial.instance.onStateChanged(),
      builder: (context, snapshot) {
        // FlutterBluetoothSerial.instance.state.then((value) => null)
        if (!snapshot.hasData) {
          BluetoothRepository.requestEnableBluetooth().then((value) {
            print('valor despues $value !snapshot.hasData');
            if (!value) {
              Future.delayed(const Duration(seconds: 2),
                  () => Navigator.maybePop(context));
            }
          });
          return const NoDataView();
        }

        if (snapshot.data == null) {
          BluetoothRepository.requestEnableBluetooth().then((value) {
            print('valor despues $value snapshot.data == null');
            if (!value) {
              Future.delayed(const Duration(seconds: 2),
                  () => Navigator.maybePop(context));
            }
          });
          return const NoDataView();
        }

        if (!snapshot.data!.isEnabled) {
          BluetoothRepository.requestEnableBluetooth().then((value) {
            print('valor despues $value !snapshot.data!.isEnabled');
            if (!value) {
              Future.delayed(const Duration(seconds: 2),
                  () => Navigator.maybePop(context));
            }
          });
          return const NoEnabledBluetooth();
        }

        return const BluetoothEnabledView();
      },
    );
  }
}

class NoDataView extends StatelessWidget {
  const NoDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Consts.defaultPadding * 3,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.bluetooth_disabled,
              size: 100,
              color: Consts.primary,
            ),
            SizedBox(height: Consts.defaultPadding),
            Text(
              "Sin datos",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Consts.defaultPadding / 2),
          ],
        ),
      ),
    );
  }
}

class NoEnabledBluetooth extends StatelessWidget {
  const NoEnabledBluetooth({Key? key}) : super(key: key);

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
              Icons.bluetooth_disabled,
              size: 100,
              color: Consts.primary,
            ),
            const SizedBox(height: Consts.defaultPadding),
            const Text(
              "Activa el Bluetooth",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            Text(
              "Asegurate de tener el Bluetooth activado y que tu dispositivo este en modo configuración",
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

class BluetoothEnabledView extends StatelessWidget {
  const BluetoothEnabledView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Text(
        'connected',
        style: textTheme.headline3,
      ),
    );
  }
}

class PairedDevices extends StatelessWidget {
  const PairedDevices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PairedDevicesCubit()..init(),
      child: BlocBuilder<PairedDevicesCubit, List<BluetoothDevice>>(
        builder: (context, pairedDevices) {
          if (pairedDevices.isEmpty) {
            return const NoDevicesFound();
          }

          return UniqueAvailableDevice(device: pairedDevices[0]);
          // if (pairedDevices.length == 1) {}

          // return ListView.builder(
          //   itemBuilder: (context, index) {
          //     return Column(
          //       children: [
          //         Text(pairedDevices[index].name ?? ''),
          //         Text(pairedDevices[index].address),
          //         Text(pairedDevices[index].address),
          //       ],
          //     );
          //   },
          //   itemCount: pairedDevices.length,
          // );
        },
      ),
    );
  }
}

class UniqueAvailableDevice extends StatelessWidget {
  const UniqueAvailableDevice({Key? key, required this.device})
      : super(key: key);
  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final elevatedButtonTheme = Theme.of(context).elevatedButtonTheme;

    return BlocProvider(
      create: (context) => SetupDeviceCubit(),
      child: BlocBuilder<SetupDeviceCubit, BluetoothDevice?>(
        builder: (context, deviceConnected) {
          if (deviceConnected == null) {
            return DeviceFound(device: device);
          }

          return const SetupDevice();
        },
      ),
    );
  }
}

class DeviceFound extends StatelessWidget {
  const DeviceFound({Key? key, required this.device}) : super(key: key);
  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final elevatedButtonTheme = Theme.of(context).elevatedButtonTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Consts.defaultPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.done_all,
              size: 100,
              color: Consts.primary,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            Text(
              "Se encontró el siguiente dispositivo:",
              style: textTheme.headline4?.copyWith(
                color: Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            Text(
              device.name ?? "Dispositivo sin nombre",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Consts.primary.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            Text(
              "¿Deseas continuar con la configuración de este dispositivo?",
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Consts.defaultPadding * 2),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Consts.defaultPadding,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Consts.primary.shade600,
                  shape: CustomTheme.buttonShape,
                  minimumSize: const Size.fromHeight(40), // NEW
                ),
                onPressed: () async {
                  await futureLoadingIndicator(context,
                      context.read<SetupDeviceCubit>().connectDevice(device));
                },
                child: Text(
                  "CONTINUAR",
                  style: textTheme.button?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoDevicesFound extends StatelessWidget {
  const NoDevicesFound({Key? key}) : super(key: key);

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
              Icons.bluetooth_disabled,
              size: 100,
              color: Consts.primary,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            const Text(
              "No se encontraron dispositivos",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Consts.defaultPadding / 2),
            Text(
              "Asegurate de que tu dispositivo este en modo configuración y que este vinculado con tu teléfono.",
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Consts.defaultPadding * 2),
            OutlinedButton(
              onPressed: () {
                Navigator.maybePop(context);
              },
              child: const Text("Regresar"),
            ),
          ],
        ),
      ),
    );
  }
}

class SetupDevice extends StatefulWidget {
  const SetupDevice({Key? key}) : super(key: key);

  @override
  State<SetupDevice> createState() => _SetupDeviceState();
}

class _SetupDeviceState extends State<SetupDevice> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyFridge = GlobalKey<FormState>();
  final _formKeyCoordinator = GlobalKey<FormState>();
  final _formKeyInternet = GlobalKey<FormState>();
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
      create: (context) => DeviceConfigurationCubit(),
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
          return BlocBuilder<SetupDeviceCubit, BluetoothDevice?>(
            builder: (context, device) {
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
                                  device!.name ?? "Dispositivo sin nombre",
                                  style: textTheme.headline2,
                                ),
                              ),
                              Center(child: Text(device.address)),

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
                                    deviceConfiguration.minTemperature
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Expanded(
                                    child: Slider(
                                      min: -20,
                                      max: deviceConfiguration.maxTemperature -
                                          1,
                                      value: deviceConfiguration.minTemperature
                                          .toDouble(),
                                      onChanged: (value) => context
                                          .read<DeviceConfigurationCubit>()
                                          .onChangedMinTemperature(
                                              value.toInt()),
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
                                    deviceConfiguration.maxTemperature
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Expanded(
                                    child: Slider(
                                      min: deviceConfiguration.minTemperature +
                                          1,
                                      max: 30,
                                      value: deviceConfiguration.maxTemperature
                                          .toDouble(),
                                      onChanged: (value) => context
                                          .read<DeviceConfigurationCubit>()
                                          .onChangedMaxTemperature(
                                              value.toInt()),
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
                                    value: deviceConfiguration
                                        .startOnCoordinatorMode,
                                    activeColor: Consts.primary,
                                    onChanged: (value) {
                                      setState(() {});
                                      context
                                          .read<DeviceConfigurationCubit>()
                                          .onChangeCommunicationModeStart(
                                              value);
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
                                    const SizedBox(
                                        height: Consts.defaultPadding),
                                    const Center(
                                      child: Text(
                                        "WiFi de la Nevera",
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
                                      'SSDI de la nevera',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// Coordinador Wifi
                                      const SizedBox(
                                          height: Consts.defaultPadding),
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
                                        autovalidateMode:
                                            AutovalidateMode.always,
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
                                        controller:
                                            passwordCoordinatorController,
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
                                              .onChangedPasswordCordinator(
                                                  value);
                                        },
                                        validator: Validators.validatePassword,
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                      ),
                                    ],
                                  ),
                                ),
                              Form(
                                key: _formKeyInternet,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        height: Consts.defaultPadding),
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
      await futureLoadingIndicator(context,
          context.read<SetupDeviceCubit>().sendData(deviceConfiguration));
    };
  }
}
