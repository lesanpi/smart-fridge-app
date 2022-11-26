part of 'cloud_messages_bloc.dart';

abstract class CloudMessagesEvent extends Equatable {
  const CloudMessagesEvent();

  @override
  List<Object> get props => [];
}

class CloudMessageInitialized extends CloudMessagesEvent {
  const CloudMessageInitialized();
}

class CloudMessageReceived extends CloudMessagesEvent {
  const CloudMessageReceived(this.deviceMessage);
  final DeviceMessage deviceMessage;
}

class CloudErrorMessageReceived extends CloudMessagesEvent {
  const CloudErrorMessageReceived(this.deviceMessage);
  final DeviceMessage deviceMessage;
}
