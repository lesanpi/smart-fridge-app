import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:wifi_led_esp8266/data/use_cases/fridge_use_case.dart';
import 'package:wifi_led_esp8266/models/temperature_stat.dart';

part 'temperature_stats_event.dart';
part 'temperature_stats_state.dart';

class TemperatureStatsBloc
    extends Bloc<TemperatureStatsEvent, TemperatureStatsState> {
  TemperatureStatsBloc(this._fridgeUseCase, this._fridgeId)
      : super(TemperatureStatsInitial()) {
    on<TemperatureStatsGet>(onGetTemperature);
    on<TemperatureStatsRefresh>(onRefreshTemperature);
    _tickerSubscription =
        Stream.periodic(const Duration(minutes: 1)).listen((event) {
      add(TemperatureStatsRefresh());
    });
  }

  StreamSubscription<void>? _tickerSubscription;

  final FridgeUseCase _fridgeUseCase;
  final String _fridgeId;
  Future<void> onGetTemperature(
    TemperatureStatsGet event,
    Emitter<TemperatureStatsState> emit,
  ) async {
    emit(TemperatureStatsLoading());
    try {
      final stats = await _fridgeUseCase.getFridgeTemperatures(_fridgeId);
      emit(TemperatureStatsLoaded(stats));
    } catch (e) {
      emit(TemperatureStatsFailed());
    }
  }

  Future<void> onRefreshTemperature(
    TemperatureStatsRefresh event,
    Emitter<TemperatureStatsState> emit,
  ) async {
    try {
      final stats = await _fridgeUseCase.getFridgeTemperatures(_fridgeId);
      emit(TemperatureStatsLoaded(stats));
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
