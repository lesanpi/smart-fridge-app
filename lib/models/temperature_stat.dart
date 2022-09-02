// To parse this JSON data, do
//
//     final temperature = temperatureFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class TemperatureStat {
  TemperatureStat({
    required this.temp,
    required this.timestamp,
  });

  final double temp;
  final DateTime timestamp;

  factory TemperatureStat.fromJson(String str) =>
      TemperatureStat.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TemperatureStat.fromMap(Map<String, dynamic> json) => TemperatureStat(
        temp: json["temp"].toDouble(),
        timestamp: DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toMap() => {
        "temp": temp,
        "timestamp": timestamp.toIso8601String(),
      };
}
