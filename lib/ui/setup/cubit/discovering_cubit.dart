import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

enum DiscoveringState { discovering, found, notFound }

class DiscoveringCubit extends Cubit<DiscoveringState> {
  DiscoveringCubit() : super(DiscoveringState.discovering);
  StreamSubscription<BluetoothDiscoveryResult>? _discoveryResult;

  void init() async {
    print("init discovering cubit");
    final _isDiscovering = await FlutterBluetoothSerial.instance.isDiscovering;
    if (_isDiscovering == null || _isDiscovering == false) {
      print('no esta descubriendo');
      if (_discoveryResult != null) {
        _discoveryResult!.cancel();
      }

      _discoveryResult =
          FlutterBluetoothSerial.instance.startDiscovery().listen((event) {
        print(event.device.address);
        print(event.device.name);
        print(event.rssi);
      });
    }
  }
}

class PairedDevicesCubit extends Cubit<List<BluetoothDevice>> {
  PairedDevicesCubit() : super([]);
  // StreamSubscription<BluetoothDiscoveryResult>? _discoveryResult;

  void init() async {
    List<BluetoothDevice> _bondedDevicesFound =
        await FlutterBluetoothSerial.instance.getBondedDevices();

    _bondedDevicesFound = _bondedDevicesFound
        .where((element) => element.name == 'Controlador Nevera')
        .toList();

    emit([_bondedDevicesFound.first]);
  }
}
