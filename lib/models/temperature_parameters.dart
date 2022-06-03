import 'package:equatable/equatable.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';

class TemperatureParameter extends Equatable {
  const TemperatureParameter(
      {required this.minTemperature, required this.maxTemperature});

  final int minTemperature;
  final int maxTemperature;

  TemperatureParameter copyWith({
    int? minTemperature,
    int? maxTemperature,
  }) =>
      TemperatureParameter(
        minTemperature: minTemperature ?? this.minTemperature,
        maxTemperature: maxTemperature ?? this.maxTemperature,
      );

  factory TemperatureParameter.initialFromFridgeState(
          FridgeState? fridgeState) =>
      TemperatureParameter(
        minTemperature: fridgeState!.minTemperature,
        maxTemperature: fridgeState.maxTemperature,
      );

  @override
  List<Object?> get props => [minTemperature, maxTemperature];
}
