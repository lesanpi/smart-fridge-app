import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/data/repositories/local_repository.dart';
import 'package:wifi_led_esp8266/data/use_cases/fridge_use_case.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/models/communication_mode.dart';

class FridgeStateCubit extends Cubit<FridgeState?> {
  FridgeStateCubit(this._localRepository, this._fridgeUseCase)
      : super(_localRepository.fridgeSelected);

  final LocalRepository _localRepository;
  final FridgeUseCase _fridgeUseCase;
  StreamSubscription<FridgeState?>? _fridgeStateStream;

  void init() {
    if (_localRepository.connectionInfo == null) return;

    _fridgeStateStream ??= _localRepository.fridgeSelectedStream.listen(
      (fridgeState) {
        emit(fridgeState);
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

  void changeName(String name) {
    if (name.isNotEmpty) {
      _localRepository.changeName(state!.id, name);
    }
  }

  void restoreFactory() async {
    // TODO: Return Message
    final success = await _fridgeUseCase.deleteFridge(state!.id);
    if (success) {
      _localRepository.factoryRestore(state!.id);
      print('success');
    }
  }

  void toggleLight() {
    if (state != null) {
      _localRepository.toggleLight(state!.id);
    }
  }

  void setDesiredTemperature(int temperature) {
    if (state != null) {
      _localRepository.setDesiredTemperature(state!.id, temperature);
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
