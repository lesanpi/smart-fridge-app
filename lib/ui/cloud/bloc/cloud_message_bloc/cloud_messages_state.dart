part of 'cloud_messages_bloc.dart';

class CloudMessagesState extends Equatable {
  const CloudMessagesState({
    this.errorMessage,
    this.deviceMessage,
  });
  final DeviceMessage? errorMessage;
  final DeviceMessage? deviceMessage;

  CloudMessagesState copyWith({
    DeviceMessage? errorMessage,
    DeviceMessage? deviceMessage,
  }) =>
      CloudMessagesState(
        errorMessage: errorMessage ?? errorMessage,
        deviceMessage: deviceMessage ?? deviceMessage,
      );

  @override
  List<Object?> get props => [
        errorMessage,
        deviceMessage,
      ];
}
