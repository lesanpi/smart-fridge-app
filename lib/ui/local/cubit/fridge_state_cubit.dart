import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/data/repositories/local_repository.dart';
import 'package:wifi_led_esp8266/model/fridge_state.dart';
import 'package:wifi_led_esp8266/ui/comunication_mode/models/communication_mode.dart';

class FridgeStateCubit extends Cubit<FridgeState?> {
  FridgeStateCubit(this._localRepository)
      : super(_localRepository.fridgeSelected);

  final LocalRepository _localRepository;
  StreamSubscription<FridgeState?>? _fridgeStateStream;

  void init() {
    if (_localRepository.connectionInfo == null) return;

    _fridgeStateStream ??= _localRepository.fridgeSelectedStream.listen(
      (fridgesState) {
        // print(fridgesState?.ssidCoordinator);
        // print(fridgesState?.ssid);
        emit(fridgesState);
        // final _newFridgeState = fridgesStates.firstWhere(
        //   (fridgeState) {
        //     if (_localRepository.connectionInfo == null) return false;

        //     return fridgeState?.id == _localRepository.connectionInfo!.id;
        //   },
        //   orElse: () {
        //     return null;
        //   },
        // );
        // // print('temperature cambiada ${_newFridgeState?.temperature}');
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

  void toggleLight() {
    if (state != null) {
      _localRepository.toggleLight(state!.id);
    }
  }

  void setMaxTemperature(int temperature) {
    if (state != null) {
      _localRepository.setMaxTemperature(state!.id, temperature);
    }
  }

  void setMinTemperature(int temperature) {
    if (state != null) {
      _localRepository.setMinTemperature(state!.id, temperature);
    }
  }

  void setStandaloneMode(CommunicationMode communicationMode) {
    if (state != null) {
      _localRepository.setStandaloneMode(
        state!.id,
        communicationMode.ssid,
        // communicationMode.password,
      );
    }
  }

  void setCoordinatorMode(CommunicationMode communicationMode) {
    if (state != null) {
      _localRepository.setCoordinatorMode(
        state!.id,
        communicationMode.ssidCoordinator,
        communicationMode.passwordCoordinator,
      );
    }
  }
}
