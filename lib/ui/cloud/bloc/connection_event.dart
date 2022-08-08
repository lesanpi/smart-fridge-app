part of 'connection_bloc.dart';

abstract class CloudConnectionEvent {}

class CloudConnectionInit extends CloudConnectionEvent {}

class CloudConnectionConnect extends CloudConnectionEvent {}

class CloudConnectionDisconnect extends CloudConnectionEvent {}

class CloudConnectionUpdate extends CloudConnectionEvent {
  CloudConnectionUpdate(this.fridgeStates);
  final List<FridgeState> fridgeStates;
}
