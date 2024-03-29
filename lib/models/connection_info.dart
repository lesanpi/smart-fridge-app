class ConnectionInfo {
  ConnectionInfo({
    required this.standalone,
    required this.id,
    required this.ssid,
    required this.name,
    required this.configurationMode,
  });

  bool standalone;
  String id;
  String ssid;
  String name;
  bool configurationMode;

  factory ConnectionInfo.fromJson(Map<String, dynamic> json) => ConnectionInfo(
        standalone: json["standalone"],
        id: json["id"],
        ssid: json["ssid"],
        name: json["name"],
        configurationMode: json["configurationMode"],
      );

  Map<String, dynamic> toJson() => {
        "standalone": standalone,
        "id": id,
        "ssid": ssid,
        "name": name,
        "configurationMode": configurationMode,
      };
}
