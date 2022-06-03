import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:wifi_led_esp8266/data/repositories/bluetooth_repository.dart';

class EnableBluetoothCubit extends Cubit<bool> {
  EnableBluetoothCubit(bool initialState) : super(initialState);

  StreamSubscription<BluetoothState>? _onStateChangedStream;

  void init() async {
    print('inicializando blueetoth');
    final _bluetoothState = await FlutterBluetoothSerial.instance.state;

    try {
      emit(_bluetoothState.isEnabled);
    } catch (e) {}

    if (_onStateChangedStream != null) {
      _onStateChangedStream!.cancel();
    }

    _onStateChangedStream = FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((bluetoothState) {
      print('nuevo bluetoothState $bluetoothState');

      try {
        emit(bluetoothState.isEnabled);
      } catch (e) {}
    });
  }

  @override
  Future<void> close() {
    if (_onStateChangedStream != null) {
      _onStateChangedStream!.cancel();
      _onStateChangedStream = null;
    }

    return super.close();
  }
}
