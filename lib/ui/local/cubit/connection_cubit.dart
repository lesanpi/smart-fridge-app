import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/data/repositories/local_repository.dart';
import 'package:wifi_led_esp8266/data/use_cases/auth_use_case.dart';
import 'package:wifi_led_esp8266/models/connection_info.dart';

class LocalConnectionState extends Equatable {
  const LocalConnectionState(
      {this.connectionInfo, this.isLoading = false, this.finish = true});
  final ConnectionInfo? connectionInfo;
  final bool isLoading;
  final bool finish;

  @override
  List<Object?> get props => [connectionInfo, isLoading];
}

class ConnectionCubit extends Cubit<LocalConnectionState> {
  ConnectionCubit(this._authUseCase, this._localRepository)
      : super(LocalConnectionState(
            connectionInfo: _localRepository.connectionInfo));

  final AuthUseCase _authUseCase;
  final LocalRepository _localRepository;

  StreamSubscription<ConnectionInfo?>? _connectionInfoStream;

  void init() {
    _connectionInfoStream =
        // ignore: unnecessary_cast
        _localRepository.connectionInfoStream.listen((connectionInfo) {
      if (connectionInfo != null) {
        emit(LocalConnectionState(connectionInfo: connectionInfo));
      } else {
        emit(const LocalConnectionState());
      }
    }) as StreamSubscription<ConnectionInfo?>?;
  }

  Future<void> connect(String password) async {
    emit(LocalConnectionState(
        connectionInfo: state.connectionInfo, isLoading: true));

    final user = _authUseCase.currentUser;

    if (user == null) {
      return;
    }

    if (_connectionInfoStream != null) {
      await _connectionInfoStream!.cancel();
      // return;
    }

    bool connected =
        await _localRepository.connect(user.id, _authUseCase.token);

    if (!connected) {
      emit(LocalConnectionState(connectionInfo: state.connectionInfo));
      // return;
    }

    emit(LocalConnectionState(connectionInfo: state.connectionInfo));

    if (_connectionInfoStream != null) {
      await _connectionInfoStream!.cancel();
    }

    _connectionInfoStream =
        _localRepository.connectionInfoStream.listen((connectionInfo) {
      if (connectionInfo != null) {
        emit(LocalConnectionState(connectionInfo: connectionInfo));
      } else {
        emit(const LocalConnectionState());
      }
    });
  }

  Future<void> disconnect() async {
    if (_connectionInfoStream != null) {
      await _connectionInfoStream!.cancel();
    }
    _localRepository.client.disconnect();
    emit(const LocalConnectionState());
  }

  @override
  Future<void> close() {
    if (_connectionInfoStream != null) {
      _connectionInfoStream!.cancel();
    }
    // _localRepository.client.disconnect();

    return super.close();
  }
}
