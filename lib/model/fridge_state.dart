// To parse this JSON data, do
//
//     final fridgeState = fridgeStateFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

FridgeState fridgeStateFromJson(String str) =>
    FridgeState.fromJson(json.decode(str));

String fridgeStateToJson(FridgeState data) => json.encode(data.toJson());

class FridgeState {
  FridgeState({
    required this.id,
    required this.temperature,
    required this.light,
    required this.compressor,
    required this.door,
    required this.maxTemperature,
    required this.minTemperature,
    required this.standalone,
    required this.ssid,
    required this.ssidCoordinator,
  });

  String id;
  int temperature;
  bool light;
  bool compressor;
  bool door;
  int maxTemperature;
  int minTemperature;
  bool standalone;
  String ssid;
  String ssidCoordinator;

  factory FridgeState.fromJson(Map<String, dynamic> json) => FridgeState(
        id: json["id"],
        temperature: json["temperature"],
        light: json["light"],
        compressor: json["compressor"],
        door: json["door"],
        maxTemperature: json["maxTemperature"],
        minTemperature: json["minTemperature"],
        standalone: json["standalone"],
        ssid: json["ssid"],
        ssidCoordinator: json["ssidCoordinator"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "temperature": temperature,
        "light": light,
        "compressor": compressor,
        "door": door,
        "maxTemperature": maxTemperature,
        "minTemperature": minTemperature,
        "standalone": standalone,
        "ssid": ssid,
      };
}
