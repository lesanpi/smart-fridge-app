import 'package:meta/meta.dart';
import 'dart:convert';

class ConnectionInfo {
  ConnectionInfo({
    required this.standalone,
    required this.id,
    required this.ssid,
    required this.configurationMode,
  });

  bool standalone;
  String id;
  String ssid;
  bool configurationMode;

  factory ConnectionInfo.fromJson(Map<String, dynamic> json) => ConnectionInfo(
        standalone: json["standalone"],
        id: json["id"],
        ssid: json["ssid"],
        configurationMode: json["configurationMode"],
      );

  Map<String, dynamic> toJson() => {
        "standalone": standalone,
        "id": id,
        "ssid": ssid,
        "configurationMode": configurationMode,
      };
}
