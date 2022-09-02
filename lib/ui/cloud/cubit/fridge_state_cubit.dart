import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/data/repositories/local_repository.dart';
import 'package:wifi_led_esp8266/data/repositories/repositories.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/models/communication_mode.dart';

class FridgeStateCubit extends Cubit<FridgeState?> {
  FridgeStateCubit(this._cloudRepository)
      : super(_cloudRepository.fridgeSelected);

  final CloudRepository _cloudRepository;
  StreamSubscription<FridgeState?>? _fridgeStateStream;

  void init() {
    _fridgeStateStream ??= _cloudRepository.fridgeSelectedStream.listen(
      (fridgeState) {
        emit(fridgeState);
      },
    );
  }

  Future<void> disconnect() async {
    if (_fridgeStateStream != null) {
      await _fridgeStateStream!.cancel();
    }
    _cloudRepository.client.disconnect();
    emit(null);
  }

  @override
  Future<void> close() {
    if (_fridgeStateStream != null) {
      _fridgeStateStream!.cancel();
    }
    return super.close();
  }

  void changeName(String name) {
    if (name.isNotEmpty) {
      _cloudRepository.changeName(state!.id, name);
    }
  }

  void setDesiredTemperature(int temperature) {
    if (state != null) {
      _cloudRepository.setDesiredTemperature(state!.id, temperature);
    }
  }

  void toggleLight() {
    if (state != null) {
      _cloudRepository.toggleLight(state!.id);
    }
  }

  void setMaxTemperature(int temperature) {
    if (state != null) {
      _cloudRepository.setMaxTemperature(state!.id, temperature);
    }
  }

  void setMinTemperature(int temperature) {
    if (state != null) {
      _cloudRepository.setMinTemperature(state!.id, temperature);
    }
  }

  void setStandaloneMode(CommunicationMode communicationMode) {
    if (state != null) {
      _cloudRepository.setStandaloneMode(
        state!.id,
        communicationMode.ssid,
        // communicationMode.password,
      );
    }
  }

  void setCoordinatorMode(CommunicationMode communicationMode) {
    if (state != null) {
      _cloudRepository.setCoordinatorMode(
        state!.id,
        communicationMode.ssidCoordinator,
        communicationMode.passwordCoordinator,
      );
    }
  }
}
