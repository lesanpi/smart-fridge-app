import 'package:meta/meta.dart';
import 'dart:convert';

class ConnectionInfo {
  ConnectionInfo({
    required this.standalone,
    required this.fridges,
    required this.ssid,
  });

  bool standalone;
  List<FridgePreview> fridges;
  String ssid;

  factory ConnectionInfo.fromJson(Map<String, dynamic> json) => ConnectionInfo(
        standalone: json["standalone"],
        fridges: List<FridgePreview>.from(
            json["fridges"].map((x) => FridgePreview.fromJson(x))),
        ssid: json["ssid"],
      );

  Map<String, dynamic> toJson() => {
        "standalone": standalone,
        "fridges": List<dynamic>.from(fridges.map((x) => x.toJson())),
        "ssid": ssid,
      };
}

class FridgePreview {
  FridgePreview({
    required this.id,
    required this.name,
    required this.temperature,
    required this.state,
  });

  String id;
  String name;
  int temperature;
  String state;

  factory FridgePreview.fromJson(Map<String, dynamic> json) => FridgePreview(
        id: json["id"],
        name: json["name"],
        temperature: json["temperature"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "temperature": temperature,
        "state": state,
      };
}
