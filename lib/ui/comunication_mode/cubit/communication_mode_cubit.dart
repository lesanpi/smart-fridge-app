import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/model/fridge_state.dart';
import 'package:wifi_led_esp8266/ui/comunication_mode/models/communication_mode.dart';

class CommunicationModeCubit extends Cubit<CommunicationMode> {
  CommunicationModeCubit(CommunicationMode initialState) : super(initialState);

  void onChangedSsid(String ssid) => emit(state.copyWith(ssid: ssid));

  void onChangedSsidCoordinator(String ssidCoordinator) =>
      emit(state.copyWith(ssidCoordinator: ssidCoordinator));

  void onChangedPassword(String password) =>
      emit(state.copyWith(password: password));

  void onChangedPasswordCoordinator(String passwordCoordinator) =>
      emit(state.copyWith(passwordCoordinator: passwordCoordinator));

  void set(FridgeState fridgeState) =>
      emit(CommunicationMode.fromFridgeState(fridgeState));
}
