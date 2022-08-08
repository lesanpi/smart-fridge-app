part of 'connection_bloc.dart';

abstract class LocalConnectionState extends Equatable {
  const LocalConnectionState(this.connectionInfo);
  final ConnectionInfo? connectionInfo;

  @override
  List<Object?> get props => [connectionInfo, connectionInfo?.id];
}

class LocalConnectionInitial extends LocalConnectionState {
  const LocalConnectionInitial() : super(null);
}

class LocalConnectionLoading extends LocalConnectionState {
  const LocalConnectionLoading() : super(null);
}

class LocalConnectionWaiting extends LocalConnectionState {
  const LocalConnectionWaiting() : super(null);
}

class LocalConnectionLoaded extends LocalConnectionState {
  const LocalConnectionLoaded(ConnectionInfo connectionInfo)
      : super(connectionInfo);
}

class LocalConnectionDisconnected extends LocalConnectionState {
  const LocalConnectionDisconnected() : super(null);
}
