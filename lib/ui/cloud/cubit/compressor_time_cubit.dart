import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';

class CompressorTimeCubit extends Cubit<int> {
  CompressorTimeCubit(int initialMinutes) : super(initialMinutes);

  void onChangedMinutes(int value) => emit(value);

  void set(FridgeState fridgeState) => emit(fridgeState.compresorMinutesToWait);
}
