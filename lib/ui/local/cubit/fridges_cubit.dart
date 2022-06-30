import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/data/repositories/local_repository.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';

class FridgesCubit extends Cubit<List<FridgeState>> {
  FridgesCubit(this._localRepository) : super(_localRepository.fridgesState);
  final LocalRepository _localRepository;
  StreamSubscription<List<FridgeState>>? _fridgesStateStream;

  void init() {
    print("inicializando fridge list cubit");
    if (_localRepository.connectionInfo == null) return;

    // if (!_localRepository.connectionInfo!.standalone) return;

    print("Escuchando cambios de estado");
    _fridgesStateStream ??= _localRepository.fridgesStateStream.listen(
      (fridgesState) {
        print('nuevos cambios');
        print(fridgesState.map((e) => e.toJson()).toList());
        print('emitiendo');
        emit(fridgesState);
        print('listo la emision');
        emit(fridgesState.map((e) => e).toList());
      },
    );
  }

  Future<void> disconnect() async {
    if (_fridgesStateStream != null) {
      await _fridgesStateStream!.cancel();
    }
    _localRepository.client.disconnect();
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
