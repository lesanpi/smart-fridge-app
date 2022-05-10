import 'package:meta/meta.dart';
import 'dart:convert';

class ConnectionInfo {
  ConnectionInfo({
    required this.standalone,
    required this.id,
    required this.ssid,
  });

  bool standalone;
  String id;
  String ssid;

  factory ConnectionInfo.fromJson(Map<String, dynamic> json) => ConnectionInfo(
        standalone: json["standalone"],
        id: json["id"],
        ssid: json["ssid"],
      );

  Map<String, dynamic> toJson() => {
        "standalone": standalone,
        "id": id,
        "ssid": ssid,
      };
}
