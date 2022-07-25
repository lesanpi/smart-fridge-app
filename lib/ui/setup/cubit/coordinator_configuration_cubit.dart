import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/data/repositories/repositories.dart';
import 'package:wifi_led_esp8266/models/coordinator_configuration.dart';

class CoordinatorConfigurationCubit extends Cubit<CoordinatorConfiguration> {
  CoordinatorConfigurationCubit(this._localRepository)
      : super(CoordinatorConfiguration.initial());
  final LocalRepository _localRepository;

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

  Future<void> configureCoordinator(
      CoordinatorConfiguration coordinatorConfiguration) async {
    print(coordinatorConfiguration.toJson());
    _localRepository.configureCoordinator(coordinatorConfiguration);
    await Future.delayed(const Duration(seconds: 1));
  }
}
