import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/data/repositories/bluetooth_repository.dart';
import 'package:wifi_led_esp8266/theme.dart';
import 'package:wifi_led_esp8266/ui/setup/cubit/discovering_cubit.dart';
import 'package:wifi_led_esp8266/ui/setup/cubit/enable_bluetooth_cubit.dart';
import 'package:wifi_led_esp8266/ui/setup/cubit/setup_device_cubit.dart';
import 'package:wifi_led_esp8266/ui/setup/widgets/setup_appbar.dart';
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

class SetupDevice extends StatelessWidget {
  const SetupDevice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<SetupDeviceCubit, BluetoothDevice?>(
      builder: (context, device) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Consts.defaultPadding,
              vertical: Consts.defaultPadding * 2,
            ),
            child: Column(
              children: [
                Text(device!.name ?? "Dispositivo sin nombre"),
                Text(device.address),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Consts.primary.shade600,
                    shape: CustomTheme.buttonShape,
                    minimumSize: const Size.fromHeight(40), // NEW
                  ),
                  onPressed: () async {
                    await futureLoadingIndicator(
                        context, context.read<SetupDeviceCubit>().sendData());
                  },
                  child: Text(
                    "CONTINUAR",
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
  }
}
