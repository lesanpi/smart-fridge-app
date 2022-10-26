import 'dart:convert';

AuthUser authUserFromJson(String str) => AuthUser.fromJson(json.decode(str));
AuthUser authUserFromJsonStorage(String str) =>
    AuthUser.fromStorage(json.decode(str));

String authUserToJson(AuthUser data) => json.encode(data.toJson());

class AuthUser {
  AuthUser({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.fridges,
  });
  final String id;
  final String email;
  final String phone;
  final String name;
  final List<String> fridges;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
        fridges:
            List<String>.from(json["fridges"].map((x) => x["id"] as String)),
      );

  factory AuthUser.fromStorage(Map<String, dynamic> json) => AuthUser(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
        fridges: List<String>.from(json["fridges"].map((x) {
          return x as String;
        })),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "phone": phone,
        "fridges": fridges,
      };
}
