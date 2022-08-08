part of 'connection_bloc.dart';

abstract class LocalConnectionEvent {}

class LocalConnectionInit extends LocalConnectionEvent {}

class LocalConnectionConnect extends LocalConnectionEvent {}

class LocalConnectionDisconnect extends LocalConnectionEvent {}

class LocalConnectionUpdate extends LocalConnectionEvent {
  LocalConnectionUpdate(this.connectionInfo);
  final ConnectionInfo? connectionInfo;
}
