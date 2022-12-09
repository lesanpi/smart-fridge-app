import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:wifi_led_esp8266/data/repositories/auth_repository.dart';
import 'package:wifi_led_esp8266/data/repositories/local_repository.dart';
import 'package:wifi_led_esp8266/data/use_cases/auth_use_case.dart';
import 'package:wifi_led_esp8266/models/connection_info.dart';

part 'connection_state.dart';
part 'connection_event.dart';

class LocalConnectionBloc
    extends Bloc<LocalConnectionEvent, LocalConnectionState> {
  LocalConnectionBloc(this._authUseCase, this._localRepository)
      : super(const LocalConnectionInitial()) {
    on<LocalConnectionInit>(init);
    on<LocalConnectionConnect>(connect);
    on<LocalConnectionDisconnect>(disconnect);
    on<LocalConnectionUpdate>(update);
  }

  final AuthUseCase _authUseCase;
  final LocalRepository _localRepository;

  StreamSubscription<ConnectionInfo?>? _connectionInfoStream;

  void update(LocalConnectionUpdate event, Emitter<LocalConnectionState> emit) {
    if (event.connectionInfo != null) {
      emit(LocalConnectionLoaded(event.connectionInfo!));
    } else {
      emit(const LocalConnectionDisconnected());
    }
  }

  void init(LocalConnectionInit event, Emitter<LocalConnectionState> emit) {
    final connectionInfo = _localRepository.connectionInfo;

    if (connectionInfo != null) {
      emit(LocalConnectionLoaded(connectionInfo));
    } else if (_localRepository.client.connectionStatus?.state ==
        MqttConnectionState.connecting) {
      emit(const LocalConnectionLoading());
    }
    _connectionInfoStream =
        _localRepository.connectionInfoStream.listen((connectionInfo) {
      add(LocalConnectionUpdate(connectionInfo));
    });
  }

  Future<void> connect(
      LocalConnectionConnect event, Emitter<LocalConnectionState> emit) async {
    emit(const LocalConnectionLoading());

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
      emit(const LocalConnectionDisconnected());
      // return;
    } else {
      emit(const LocalConnectionWaiting());
    }

    if (_connectionInfoStream != null) {
      await _connectionInfoStream!.cancel();

      _connectionInfoStream =
          _localRepository.connectionInfoStream.listen((connectionInfo) {
        try {
          add(LocalConnectionUpdate(connectionInfo));
        } catch (e) {}
      });
    }
  }

  Future<void> disconnect(LocalConnectionDisconnect event,
      Emitter<LocalConnectionState> emit) async {
    if (_connectionInfoStream != null) {
      await _connectionInfoStream!.cancel();
    }
    _localRepository.client.disconnect();
    emit(const LocalConnectionDisconnected());
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
