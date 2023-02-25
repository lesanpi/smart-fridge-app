import 'dart:convert';

import 'package:wifi_led_esp8266/models/device_configuration.dart';
// import 'package:wifi_led_esp8266/models/fridge_state.dart';

class ControllerConfiguration extends DeviceConfiguration {
  const ControllerConfiguration({
    required this.name,
    required this.desiredTemperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.ssid,
    required this.ssidCoordinator,
    required this.ssidInternet,
    required this.password,
    required this.passwordCoordinator,
    required this.passwordInternet,
    required this.startOnCoordinatorMode,
    required this.compresorMinutesToWait,
  });

  final String name;
  final int desiredTemperature;
  final int minTemperature;
  final int maxTemperature;
  final int compresorMinutesToWait;
  final String ssid;
  final String ssidCoordinator;
  final String ssidInternet;
  final String password;
  final String passwordCoordinator;
  final String passwordInternet;
  final bool startOnCoordinatorMode;

  ControllerConfiguration copyWith({
    String? name,
    int? desiredTemperature,
    int? minTemperature,
    int? maxTemperature,
    int? compresorMinutesToWait,
    bool? startOnCoordinatorMode,
    String? ssid,
    String? ssidCoordinator,
    String? ssidInternet,
    String? password,
    String? passwordCoordinator,
    String? passwordInternet,
  }) =>
      ControllerConfiguration(
        desiredTemperature: desiredTemperature ?? this.desiredTemperature,
        name: name ?? this.name,
        minTemperature: minTemperature ?? this.minTemperature,
        maxTemperature: maxTemperature ?? this.maxTemperature,
        compresorMinutesToWait:
            compresorMinutesToWait ?? this.compresorMinutesToWait,
        ssid: ssid ?? this.ssid,
        ssidCoordinator: ssidCoordinator ?? this.ssidCoordinator,
        ssidInternet: ssidInternet ?? this.ssidInternet,
        password: password ?? this.password,
        passwordCoordinator: passwordCoordinator ?? this.passwordCoordinator,
        passwordInternet: passwordInternet ?? this.passwordInternet,
        startOnCoordinatorMode:
            startOnCoordinatorMode ?? this.startOnCoordinatorMode,
      );

  factory ControllerConfiguration.initial() => const ControllerConfiguration(
        desiredTemperature: 15,
        name: "",
        minTemperature: -20,
        maxTemperature: 30,
        startOnCoordinatorMode: false,
        compresorMinutesToWait: 7,
        ssid: "",
        ssidCoordinator: "",
        ssidInternet: "",
        password: "",
        passwordCoordinator: "",
        passwordInternet: "",
      );

  @override
  List<Object?> get props => [
        name,
        desiredTemperature,
        minTemperature,
        maxTemperature,
        ssid,
        ssidCoordinator,
        ssidInternet,
        password,
        passwordCoordinator,
        passwordInternet,
        startOnCoordinatorMode,
        compresorMinutesToWait,
      ];

  factory ControllerConfiguration.fromJson(String str) =>
      ControllerConfiguration.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ControllerConfiguration.fromMap(Map<String, dynamic> json) =>
      ControllerConfiguration(
        name: json["name"],
        desiredTemperature: json["desiredTemperature"],
        minTemperature: json["minTemperature"],
        maxTemperature: json["maxTemperature"],
        compresorMinutesToWait: json["compresorMinutesToWait"],
        ssid: json["ssid"],
        ssidCoordinator: json["ssidCoordinator"],
        ssidInternet: json["ssidInternet"],
        password: json["password"],
        passwordCoordinator: json["passwordCoordinator"],
        passwordInternet: json["passwordInternet"],
        startOnCoordinatorMode: json["startOnCoordinatorMode"],
      );

  @override
  Map<String, dynamic> toMap() => {
        "name": name,
        "desiredTemperature": desiredTemperature,
        "minTemperature": minTemperature,
        "maxTemperature": maxTemperature,
        "minutes": compresorMinutesToWait,
        "ssid": ssid,
        "ssidCoordinator": ssidCoordinator,
        "ssidInternet": ssidInternet,
        "password": password,
        "passwordCoordinator": passwordCoordinator,
        "passwordInternet": passwordInternet,
        "startOnCoordinatorMode": startOnCoordinatorMode,
      };
}
