import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wifi_led_esp8266/data/repositories/repositories.dart';
import 'package:wifi_led_esp8266/models/device_message.dart';

part 'cloud_messages_event.dart';
part 'cloud_messages_state.dart';

class CloudMessagesBloc extends Bloc<CloudMessagesEvent, CloudMessagesState> {
  CloudMessagesBloc(
    this._cloudRepository,
    this._localRepository,
  ) : super(const CloudMessagesState()) {
    on<CloudErrorMessageReceived>(_onErrorMessageReceived);
    on<CloudMessageReceived>(_onMessageReceived);
    on<CloudMessageInitialized>(_onInitialize);
    add(const CloudMessageInitialized());
  }
  final CloudRepository _cloudRepository;
  final LocalRepository _localRepository;
  StreamSubscription<DeviceMessage>? _deviceErrorMessageStream;
  StreamSubscription<DeviceMessage>? _deviceErrorLocalMessageStream;
  StreamSubscription<DeviceMessage>? _deviceMessageStream;
  StreamSubscription<DeviceMessage>? _deviceLocalMessageStream;

  void _onInitialize(
    CloudMessageInitialized event,
    Emitter<CloudMessagesState> emit,
  ) {
    _deviceMessageStream ??=
        _cloudRepository.deviceMessageStream.listen((event) {
      add(CloudMessageReceived(event));
    });

    _deviceLocalMessageStream ??=
        _localRepository.deviceMessageStream.listen((event) {
      add(CloudMessageReceived(event));
    });

    _deviceErrorMessageStream ??=
        _cloudRepository.deviceErrorMessageStream.listen((event) {
      add(CloudErrorMessageReceived(event));
    });

    _deviceErrorLocalMessageStream ??=
        _localRepository.deviceErrorMessageStream.listen((event) {
      add(CloudErrorMessageReceived(event));
    });
  }

  void _onErrorMessageReceived(
    CloudErrorMessageReceived event,
    Emitter<CloudMessagesState> emit,
  ) {
    log('messageErrorReceived Stream ${event.deviceMessage}');

    emit(state.copyWith(errorMessage: event.deviceMessage));
  }

  void _onMessageReceived(
    CloudMessageReceived event,
    Emitter<CloudMessagesState> emit,
  ) {
    log('messageReceived Stream ${event.deviceMessage}');

    emit(state.copyWith(deviceMessage: event.deviceMessage));
  }

  @override
  Future<void> close() async {
    if (_deviceMessageStream != null) {
      await _deviceMessageStream!.cancel();
    }
    if (_deviceErrorMessageStream != null) {
      await _deviceErrorMessageStream!.cancel();
    }
    return super.close();
  }
}
