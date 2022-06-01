import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/data/repositories/local_repository.dart';
import 'package:wifi_led_esp8266/model/fridge_state.dart';

class FridgeStateCubit extends Cubit<FridgeState?> {
  FridgeStateCubit(this._localRepository)
      : super(
          (_localRepository.connectionInfo == null
              ? null
              : _localRepository.getFridgeStateById(
                  _localRepository.connectionInfo!.id,
                )),
        );

  final LocalRepository _localRepository;
  StreamSubscription<List<FridgeState?>>? _fridgeStateStream;

  void init() {
    if (_localRepository.connectionInfo == null) return;

    _fridgeStateStream ??= _localRepository.fridgesStateStream.listen(
      (fridgesStates) {
        final _newFridgeState = fridgesStates.firstWhere(
          (fridgeState) {
            if (_localRepository.connectionInfo == null) return false;

            return fridgeState?.id == _localRepository.connectionInfo!.id;
          },
          orElse: () {
            return null;
          },
        );
        // print('temperature cambiada ${_newFridgeState?.temperature}');
        emit(_newFridgeState);
      },
    );
  }

  Future<void> disconnect() async {
    if (_fridgeStateStream != null) {
      await _fridgeStateStream!.cancel();
    }
    _localRepository.client.disconnect();
    emit(null);
  }

  @override
  Future<void> close() {
    if (_fridgeStateStream != null) {
      _fridgeStateStream!.cancel();
    }
    return super.close();
  }
}
