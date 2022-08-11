part of 'connection_bloc.dart';

abstract class CloudConnectionState extends Equatable {
  const CloudConnectionState(this.fridgesStates);
  final List<FridgeState> fridgesStates;

  @override
  List<Object?> get props => [
        ...fridgesStates,
        fridgesStates.isEmpty,
      ];
}

class CloudConnectionInitial extends CloudConnectionState {
  const CloudConnectionInitial() : super(const []);
}

class CloudConnectionLoading extends CloudConnectionState {
  const CloudConnectionLoading() : super(const []);
}

class CloudConnectionLoaded extends CloudConnectionState {
  const CloudConnectionLoaded(List<FridgeState> fridgesStates)
      : super(fridgesStates);
}

class CloudConnectionDisconnected extends CloudConnectionState {
  const CloudConnectionDisconnected() : super(const []);
}

class CloudConnectionWaiting extends CloudConnectionState {
  const CloudConnectionWaiting() : super(const []);
}

class CloudConnectionEmpty extends CloudConnectionState {
  const CloudConnectionEmpty() : super(const []);

  @override
  List<Object?> get props => [0, true];
}

class CloudConnectionErrorOnConnection extends CloudConnectionState {
  const CloudConnectionErrorOnConnection() : super(const []);
}
