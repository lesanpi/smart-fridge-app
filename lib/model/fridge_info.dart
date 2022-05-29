import 'dart:convert';

FridgeInfo fridgeInfoFromJson(String str) =>
    FridgeInfo.fromJson(json.decode(str));

String fridgeInfoToJson(FridgeInfo data) => json.encode(data.toJson());

class FridgeInfo {
  String id;
  String name;
  String deviceId;

  FridgeInfo({required this.id, required this.name, required this.deviceId});

  factory FridgeInfo.fromJson(Map<String, dynamic> json) => FridgeInfo(
        deviceId: json["deviceId"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "deviceId": deviceId,
        "id": id,
        "name": name,
      };
}
