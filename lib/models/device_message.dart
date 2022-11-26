import 'package:equatable/equatable.dart';

class DeviceMessage extends Equatable {
  const DeviceMessage({
    required this.error,
    required this.title,
    required this.message,
  });
  final bool error;
  final String title;
  final String message;

  @override
  List<Object?> get props => [error, title, message];

  factory DeviceMessage.fromMap(Map<String, dynamic> json, bool error) {
    return DeviceMessage(
      error: error,
      title: json['title'],
      message: json['message'],
    );
  }
}
