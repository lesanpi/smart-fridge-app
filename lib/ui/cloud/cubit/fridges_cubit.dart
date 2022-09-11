import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/data/repositories/cloud_repository.dart';
import 'package:wifi_led_esp8266/data/repositories/repositories.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/models/wifi_internet.dart';

class CloudFridgesCubit extends Cubit<List<FridgeState>> {
  CloudFridgesCubit(this._cloudRepository)
      : super(_cloudRepository.fridgesState);
  final CloudRepository _cloudRepository;
  StreamSubscription<List<FridgeState>>? _fridgesStateStream;

  void init() async {
    print("inicializando fridge list cubit");

    // await _fridgesStateStream!.cancel();
    // if (_fridgesStateStream != null) {}
    // if (!_localRepository.connectionInfo!.standalone) return;

    print("Escuchando cambios de estado");
    _fridgesStateStream ??= _cloudRepository.fridgesStateStream.listen(
      (fridgesState) {
        // print('nuevos cambios');
        print(fridgesState.map((e) => e.toJson()).toList());
        // print('emitiendo');
        emit(fridgesState);
        // print('listo la emision');
        emit(fridgesState.map((e) => e).toList());
      },
    );
  }

  Future<void> selectedFridge(FridgeState fridgeState) async {
    _cloudRepository.selectFridge(fridgeState);
  }

  Future<void> disconnect() async {
    if (_fridgesStateStream != null) {
      await _fridgesStateStream!.cancel();
    }
    _cloudRepository.client.disconnect();
    emit([]);
  }

  @override
  Future<void> close() {
    if (_fridgesStateStream != null) {
      _fridgesStateStream!.cancel();
    }
    return super.close();
  }
}
