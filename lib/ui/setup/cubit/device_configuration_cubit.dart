import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/data/repositories/repositories.dart';
import 'package:wifi_led_esp8266/data/use_cases/setup_use_case.dart';
import 'package:wifi_led_esp8266/models/controller_configuration.dart';

class DeviceConfigurationCubit extends Cubit<ControllerConfiguration> {
  DeviceConfigurationCubit(this._setupUseCase)
      : super(ControllerConfiguration.initial());
  final SetupUseCase _setupUseCase;

  void onChangedSsidInternet(String value) {
    emit(state.copyWith(ssidInternet: value));
  }

  void onChangedPasswordInternet(String value) {
    final _newState = state.copyWith(passwordInternet: value);
    emit(_newState);
  }

  void onChangedDesiredTemperature(int desiredTemperature) =>
      emit(state.copyWith(desiredTemperature: desiredTemperature));

  void onChangedMinTemperature(int minTemperature) =>
      emit(state.copyWith(minTemperature: minTemperature));

  void onChangedMaxTemperature(int maxTemperature) =>
      emit(state.copyWith(maxTemperature: maxTemperature));

  void onChangeCommunicationModeStart(bool value) {
    if (value) {
      emit(state.copyWith(startOnCoordinatorMode: value));
      return;
    }

    emit(state.copyWith(
      startOnCoordinatorMode: value,
      ssidCoordinator: "",
      passwordCoordinator: "",
    ));
  }

  void onChangedName(String value) => emit(state.copyWith(name: value));
  void onChangedSsid(String value) => emit(state.copyWith(ssid: value));
  void onChangedPassword(String value) => emit(state.copyWith(password: value));

  void onChangedSsidCoordinator(String value) =>
      emit(state.copyWith(ssidCoordinator: value));
  void onChangedPasswordCordinator(String value) =>
      emit(state.copyWith(passwordCoordinator: value));

  Future<bool> configureController(
      ControllerConfiguration deviceConfiguration) async {
    // await Future.delayed(const Duration(seconds: 1));
    print(deviceConfiguration.toJson());
    print('hola');

    final success = await _setupUseCase.configureDevice(deviceConfiguration, 0);
    return success;
  }
}
