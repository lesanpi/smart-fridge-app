import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/models/wifi_internet.dart';

class WifiInternetCubit extends Cubit<WifiInternet> {
  WifiInternetCubit(WifiInternet initialState) : super(initialState);

  void onChangedSsid(String ssid) => emit(state.copyWith(ssid: ssid));

  void onChangedPassword(String password) =>
      emit(state.copyWith(password: password));

  void set(FridgeState fridgeState) =>
      emit(WifiInternet.fromFridgeState(fridgeState));
}
