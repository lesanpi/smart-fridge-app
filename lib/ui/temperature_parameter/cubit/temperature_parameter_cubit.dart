import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/model/fridge_state.dart';
import 'package:wifi_led_esp8266/ui/temperature_parameter/models/temperature_parameters.dart';

class TemperatureParameterCubit extends Cubit<TemperatureParameter> {
  TemperatureParameterCubit(TemperatureParameter initialState)
      : super(initialState);

  void onChangedMinTemperature(int minTemperature) =>
      emit(state.copyWith(minTemperature: minTemperature));

  void onChangedMaxTemperature(int maxTemperature) =>
      emit(state.copyWith(maxTemperature: maxTemperature));

  void set(FridgeState fridgeState) =>
      emit(TemperatureParameter.initialFromFridgeState(fridgeState));
}
