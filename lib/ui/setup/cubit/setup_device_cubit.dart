import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:wifi_led_esp8266/models/device_configuration.dart';

class SetupDeviceCubit extends Cubit<BluetoothDevice?> {
  SetupDeviceCubit() : super(null);
  BluetoothConnection? _bluetoothConnection;
  Future<void> connectDevice(BluetoothDevice device) async {
    if (_bluetoothConnection != null) {
      if (_bluetoothConnection!.isConnected) {
        await _bluetoothConnection!.close();
      }
    }
    _bluetoothConnection = await BluetoothConnection.toAddress(device.address);
    if (_bluetoothConnection!.isConnected) {
      emit(device);
    }
  }

  @override
  Future<void> close() async {
    await _bluetoothConnection!.close();
    return super.close();
  }

  Future<void> sendData(DeviceConfiguration deviceConfiguration) async {
    print('tratando de enviando data');
    print(state?.address);
    print(state?.name ?? 'sin nombre');

    print(deviceConfiguration.toJson());
    if (_bluetoothConnection != null) {
      if (_bluetoothConnection!.isConnected) {
        print(ascii.encode(deviceConfiguration.toJson()));
        print(ascii.decode(ascii.encode(deviceConfiguration.toJson())));
        _bluetoothConnection!.output
            .add(ascii.encode(deviceConfiguration.toJson()));
        final result = await _bluetoothConnection!.output.allSent;
        print('result $result');
      } else {
        print('is not connected');
      }
    } else {
      print('no se pudo mandar datos por que no hay conexion');
    }
  }
}
