import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/data/repositories/auth_repository.dart';
import 'package:wifi_led_esp8266/data/repositories/local_repository.dart';
import 'package:wifi_led_esp8266/data/use_cases/auth_use_case.dart';
import 'package:wifi_led_esp8266/models/connection_info.dart';

class ConnectionCubit extends Cubit<ConnectionInfo?> {
  ConnectionCubit(this._authUseCase, this._localRepository)
      : super(_localRepository.connectionInfo);

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
          emit(connectionInfo);
        } else {
          emit(null);
        }
      }) as StreamSubscription<ConnectionInfo?>?;
    }
  }

  Future<void> connect(String password) async {
    // print('intentando conectarme localmente');
    final user = _authUseCase.currentUser;

    if (user == null) {
      return;
    }

    if (_connectionInfoStream != null) {
      await _connectionInfoStream!.cancel();
      return;
    }

    bool connected = await _localRepository.connect(user.id, password);
    if (!connected) return;

    if (_connectionInfoStream != null) {
      await _connectionInfoStream!.cancel();
    }

    _connectionInfoStream =
        _localRepository.connectionInfoStream.listen((connectionInfo) {
      if (connectionInfo != null) {
        // print(connectionInfo.id);
        emit(connectionInfo);
      } else {
        emit(null);
      }
    }) as StreamSubscription<ConnectionInfo?>?;
  }

  Future<void> disconnect() async {
    if (_connectionInfoStream != null) {
      await _connectionInfoStream!.cancel();
    }
    _localRepository.client.disconnect();
    emit(null);
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
