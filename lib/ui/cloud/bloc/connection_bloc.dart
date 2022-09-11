import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/data/repositories/auth_repository.dart';
import 'package:wifi_led_esp8266/data/repositories/local_repository.dart';
import 'package:wifi_led_esp8266/data/repositories/repositories.dart';
import 'package:wifi_led_esp8266/data/use_cases/auth_use_case.dart';
import 'package:wifi_led_esp8266/models/connection_info.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';

part 'connection_state.dart';
part 'connection_event.dart';

class CloudConnectionBloc
    extends Bloc<CloudConnectionEvent, CloudConnectionState> {
  CloudConnectionBloc(this._authUseCase, this._cloudRepository)
      : super(const CloudConnectionInitial()) {
    on<CloudConnectionInit>(init);
    on<CloudConnectionConnect>(connect);
    on<CloudConnectionDisconnect>(disconnect);
    on<CloudConnectionUpdate>(update);
  }

  final AuthUseCase _authUseCase;
  final CloudRepository _cloudRepository;

  StreamSubscription<List<FridgeState>>? _fridgesStatesStream;

  void update(CloudConnectionUpdate event, Emitter<CloudConnectionState> emit) {
    emit(const CloudConnectionLoading());
    if (event.fridgeStates.isNotEmpty) {
      emit(CloudConnectionLoaded([...event.fridgeStates]));
    } else {
      emit(const CloudConnectionEmpty());
    }
  }

  void init(
      CloudConnectionInit event, Emitter<CloudConnectionState> emit) async {
    await _authUseCase.getCurrentUser();
    final connected = _cloudRepository.conected;
    final fridgesStates = _cloudRepository.fridgesState;

    if (!connected) {
      return emit(const CloudConnectionDisconnected());
    }

    if (fridgesStates.isNotEmpty) {
      emit(CloudConnectionLoaded(fridgesStates));
    } else {
      emit(const CloudConnectionEmpty());
    }
    _fridgesStatesStream =
        _cloudRepository.fridgesStateStream.listen((fridgesStates) {
      add(CloudConnectionUpdate(fridgesStates));
    });
  }

  Future<void> connect(
      CloudConnectionConnect event, Emitter<CloudConnectionState> emit) async {
    print('await');
    emit(const CloudConnectionLoading());

    print('intentando conectarme remotamente');
    final user = _authUseCase.currentUser;

    if (user == null) {
      print('Usuario nulo');
      return;
    }

    if (_fridgesStatesStream != null) {
      print('Conexión activa haciendo return;');
      await _fridgesStatesStream!.cancel();
      // return;
    }

    bool connected = await _cloudRepository.connect();
    print('connected $connected');
    if (!connected) {
      print('emitiendo disconected');
      emit(const CloudConnectionErrorOnConnection());
      return;
    } else {
      emit(const CloudConnectionWaiting());
    }

    if (_fridgesStatesStream != null) {
      await _fridgesStatesStream!.cancel();
    }

    _fridgesStatesStream =
        _cloudRepository.fridgesStateStream.listen((fridgesStates) {
      add(CloudConnectionUpdate(fridgesStates));
    });
  }

  Future<void> disconnect(CloudConnectionDisconnect event,
      Emitter<CloudConnectionState> emit) async {
    if (_fridgesStatesStream != null) {
      await _fridgesStatesStream!.cancel();
    }
    _cloudRepository.client.disconnect();
    emit(const CloudConnectionDisconnected());
  }

  @override
  Future<void> close() {
    if (_fridgesStatesStream != null) {
      _fridgesStatesStream!.cancel();
    }

    return super.close();
  }
}
