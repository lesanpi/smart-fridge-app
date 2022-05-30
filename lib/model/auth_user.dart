import 'dart:convert';

import 'package:wifi_led_esp8266/model/fridge_info.dart';

AuthUser authUserFromJson(String str) => AuthUser.fromJson(json.decode(str));

String authUserToJson(AuthUser data) => json.encode(data.toJson());

class AuthUser {
  AuthUser({
    // required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.fridges,
  });
  // final String id;
  final String email;
  final String phone;
  final String name;
  final List<FridgeInfo> fridges;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        // id: json["id"],
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
        fridges: List<FridgeInfo>.from(
            json["fridges"].map((x) => FridgeInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "email": email,
        "name": name,
        "phone": phone,
        "fridges": List<dynamic>.from(fridges.map((x) => x.toJson())),
      };
}
