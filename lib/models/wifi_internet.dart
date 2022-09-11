import 'package:equatable/equatable.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';

class WifiInternet extends Equatable {
  const WifiInternet({
    required this.ssid,
    this.password = '',
  });
  final String ssid;
  final String password;

  factory WifiInternet.fromFridgeState(FridgeState? fridgeState) =>
      WifiInternet(
        ssid: fridgeState?.ssidInternet ?? '',
        password: '',
      );

  @override
  List<Object?> get props => [ssid, password];

  WifiInternet copyWith({
    String? ssid,
    String? password,
  }) =>
      WifiInternet(
        ssid: ssid ?? this.ssid,
        password: password ?? this.password,
      );
}
