import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/data/repositories/repositories.dart';
import 'package:wifi_led_esp8266/data/use_cases/setup_use_case.dart';
import 'package:wifi_led_esp8266/models/coordinator_configuration.dart';

class CoordinatorConfigurationCubit extends Cubit<CoordinatorConfiguration> {
  CoordinatorConfigurationCubit(this._setupUseCase)
      : super(CoordinatorConfiguration.initial());
  final SetupUseCase _setupUseCase;

  void onChangedSsidInternet(String value) {
    emit(state.copyWith(ssidInternet: value));
  }

  void onChangedPasswordInternet(String value) {
    final _newState = state.copyWith(passwordInternet: value);
    emit(_newState);
  }

  void onChangedName(String value) => emit(state.copyWith(name: value));
  void onChangedSsid(String value) => emit(state.copyWith(ssid: value));
  void onChangedPassword(String value) => emit(state.copyWith(password: value));

  Future<bool> configureCoordinator(
      CoordinatorConfiguration coordinatorConfiguration) async {
    final success = _setupUseCase.configureDevice(coordinatorConfiguration, 1);
    return success;
  }
}
