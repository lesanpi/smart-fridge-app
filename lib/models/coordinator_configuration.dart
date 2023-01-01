import 'dart:convert';

import 'package:wifi_led_esp8266/models/device_configuration.dart';
// import 'package:wifi_led_esp8266/models/fridge_state.dart';

class CoordinatorConfiguration extends DeviceConfiguration {
  const CoordinatorConfiguration({
    required this.name,
    required this.ssid,
    required this.ssidInternet,
    required this.password,
    required this.passwordInternet,
  });

  final String name;
  final String ssid;
  final String ssidInternet;
  final String password;
  final String passwordInternet;

  CoordinatorConfiguration copyWith({
    String? name,
    String? ssid,
    String? ssidInternet,
    String? password,
    String? passwordInternet,
  }) =>
      CoordinatorConfiguration(
        name: name ?? this.name,
        ssid: ssid ?? this.ssid,
        ssidInternet: ssidInternet ?? this.ssidInternet,
        password: password ?? this.password,
        passwordInternet: passwordInternet ?? this.passwordInternet,
      );

  factory CoordinatorConfiguration.initial() => const CoordinatorConfiguration(
        name: "",
        ssid: "",
        ssidInternet: "",
        password: "",
        passwordInternet: "",
      );

  @override
  List<Object?> get props => [
        name,
        ssid,
        ssidInternet,
        password,
        passwordInternet,
      ];

  factory CoordinatorConfiguration.fromJson(String str) =>
      CoordinatorConfiguration.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CoordinatorConfiguration.fromMap(Map<String, dynamic> json) =>
      CoordinatorConfiguration(
        name: json["name"],
        ssid: json["ssid"],
        ssidInternet: json["ssidInternet"],
        password: json["password"],
        passwordInternet: json["passwordInternet"],
      );

  @override
  Map<String, dynamic> toMap() => {
        "name": name,
        "ssid": ssid,
        "ssidInternet": ssidInternet,
        "password": password,
        "passwordInternet": passwordInternet,
      };
}
