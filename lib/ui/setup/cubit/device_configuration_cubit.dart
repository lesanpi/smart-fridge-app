import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/models/device_configuration.dart';

class DeviceConfigurationCubit extends Cubit<DeviceConfiguration> {
  DeviceConfigurationCubit() : super(DeviceConfiguration.initial());

  void onChangedSsidInternet(String value) {
    emit(state.copyWith(ssidInternet: value));
  }

  void onChangedPasswordInternet(String value) {
    final _newState = state.copyWith(passwordInternet: value);
    emit(_newState);
  }

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

  void onChangedSsid(String value) => emit(state.copyWith(ssid: value));
  void onChangedPassword(String value) => emit(state.copyWith(password: value));

  void onChangedSsidCoordinator(String value) =>
      emit(state.copyWith(ssidCoordinator: value));
  void onChangedPasswordCordinator(String value) =>
      emit(state.copyWith(passwordCoordinator: value));
}
