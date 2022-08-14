import 'package:equatable/equatable.dart';

abstract class DeviceConfiguration extends Equatable {
  const DeviceConfiguration();
  @override
  List<Object?> get props => [];

  Map<String, dynamic> toMap() => {};
}
