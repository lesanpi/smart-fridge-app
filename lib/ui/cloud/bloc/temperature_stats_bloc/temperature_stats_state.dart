part of 'temperature_stats_bloc.dart';

abstract class TemperatureStatsState {
  const TemperatureStatsState(this.stats);
  final List<TemperatureStat> stats;
}

class TemperatureStatsInitial extends TemperatureStatsState {
  TemperatureStatsInitial() : super([]);
}

class TemperatureStatsEmpty extends TemperatureStatsState {
  TemperatureStatsEmpty() : super([]);
}

class TemperatureStatsLoading extends TemperatureStatsState {
  TemperatureStatsLoading() : super([]);
}

class TemperatureStatsFailed extends TemperatureStatsState {
  TemperatureStatsFailed() : super([]);
}

class TemperatureStatsLoaded extends TemperatureStatsState {
  TemperatureStatsLoaded(List<TemperatureStat> stats) : super(stats);
}
