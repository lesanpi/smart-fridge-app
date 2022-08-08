import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/data/repositories/auth_repository.dart';
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
    print('inicializando conection');
    if (state != null) {
      _connectionInfoStream =
          _localRepository.connectionInfoStream.listen((connectionInfo) {
        if (connectionInfo != null) {
          // print(connectionInfo.id);
          emit(LocalConnectionState(connectionInfo: connectionInfo));
        } else {
          emit(const LocalConnectionState());
        }
      }) as StreamSubscription<ConnectionInfo?>?;
    }
  }

  Future<void> connect(String password) async {
    print('await');
    emit(LocalConnectionState(
        connectionInfo: state.connectionInfo, isLoading: true));

    print('intentando conectarme localmente');
    final user = _authUseCase.currentUser;

    if (user == null) {
      print('Usuario nulo');
      return;
    }

    if (_connectionInfoStream != null) {
      print('Conexión activa haciendo return;');
      await _connectionInfoStream!.cancel();
      // return;
    }

    bool connected = await _localRepository.connect(user.id, password);
    print('connected $connected');
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
        // print(connectionInfo.id);
        emit(LocalConnectionState(connectionInfo: connectionInfo));
      } else {
        emit(const LocalConnectionState());
      }
    }) as StreamSubscription<ConnectionInfo?>?;
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
