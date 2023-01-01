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
  }
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
}
