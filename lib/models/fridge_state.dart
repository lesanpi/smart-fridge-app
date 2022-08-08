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
    required this.maxTemperature,
    required this.minTemperature,
    required this.standalone,
    required this.ssid,
    required this.ssidCoordinator,
  });

  String id;
  String name;
  double temperature;
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
        name: json["name"],
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
        "name": name,
        "temperature": temperature,
        "light": light,
        "compressor": compressor,
        "door": door,
        "maxTemperature": maxTemperature,
        "minTemperature": minTemperature,
        "standalone": standalone,
        "ssid": ssid,
        "ssidCoordinator": ssidCoordinator,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        temperature,
        light,
        compressor,
        door,
        maxTemperature,
        minTemperature,
        ssid,
        ssidCoordinator,
      ];
}
