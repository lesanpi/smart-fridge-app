// To parse this JSON data, do
//
//     final fridgeState = fridgeStateFromJson(jsonString);

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

FridgeState fridgeStateFromJson(String str) =>
    FridgeState.fromJson(json.decode(str));

String fridgeStateToJson(FridgeState data) => json.encode(data.toJson());

class FridgeState extends Equatable {
  FridgeState({
    required this.id,
    required this.name,
    required this.temperature,
    required this.light,
    required this.compressor,
    required this.door,
    required this.desiredTemperature,
    required this.maxTemperature,
    required this.minTemperature,
    required this.standalone,
    required this.ssid,
    required this.ssidCoordinator,
    required this.isConnectedToWifi,
  });

  String id;
  String name;
  double temperature;
  bool light;
  bool compressor;
  bool door;
  int desiredTemperature;
  int maxTemperature;
  int minTemperature;
  bool standalone;
  String ssid;
  String ssidCoordinator;
  bool isConnectedToWifi;

  factory FridgeState.fromJson(Map<String, dynamic> json) => FridgeState(
        id: json["id"],
        name: json["name"],
        temperature: json["temperature"] is int
            ? (json["temperature"] as int).toDouble()
            : json["temperature"] as double,
        light: json["light"],
        compressor: json["compressor"],
        door: json["door"],
        desiredTemperature: json["desiredTemperature"],
        maxTemperature: json["maxTemperature"],
        minTemperature: json["minTemperature"],
        standalone: json["standalone"],
        ssid: json["ssid"],
        ssidCoordinator: json["ssidCoordinator"],
        isConnectedToWifi: json["isConnectedToWifi"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "temperature": temperature,
        "light": light,
        "compressor": compressor,
        "door": door,
        "desiredTemperature": desiredTemperature,
        "maxTemperature": maxTemperature,
        "minTemperature": minTemperature,
        "standalone": standalone,
        "ssid": ssid,
        "ssidCoordinator": ssidCoordinator,
        "isConnectedToWifi": isConnectedToWifi,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        temperature,
        light,
        compressor,
        door,
        desiredTemperature,
        maxTemperature,
        minTemperature,
        ssid,
        ssidCoordinator,
        isConnectedToWifi,
      ];
}
