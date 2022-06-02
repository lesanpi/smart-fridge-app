import 'package:equatable/equatable.dart';
import 'package:wifi_led_esp8266/model/fridge_state.dart';

class CommunicationMode extends Equatable {
  const CommunicationMode({
    required this.coordinatorMode,
    required this.ssid,
    required this.ssidCoordinator,
    this.password = '',
    this.passwordCoordinator = '',
  });
  final bool coordinatorMode;
  final String ssid;
  final String ssidCoordinator;
  final String password;
  final String passwordCoordinator;

  factory CommunicationMode.fromFridgeState(FridgeState? fridgeState) =>
      CommunicationMode(
        coordinatorMode: !fridgeState!.standalone,
        ssid: fridgeState.ssid,
        ssidCoordinator: fridgeState.ssidCoordinator,
        password: '',
        passwordCoordinator: '',
      );

  @override
  List<Object?> get props => [coordinatorMode, ssid, password];

  CommunicationMode copyWith({
    bool? coordinatorMode,
    String? ssid,
    String? ssidCoordinator,
    String? password,
    String? passwordCoordinator,
  }) =>
      CommunicationMode(
        coordinatorMode: coordinatorMode ?? this.coordinatorMode,
        ssid: ssid ?? this.ssid,
        ssidCoordinator: ssidCoordinator ?? this.ssidCoordinator,
        password: password ?? this.password,
        passwordCoordinator: passwordCoordinator ?? this.passwordCoordinator,
      );
}
