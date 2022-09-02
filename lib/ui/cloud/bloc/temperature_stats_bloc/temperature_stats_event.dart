part of 'temperature_stats_bloc.dart';

abstract class TemperatureStatsEvent {
  const TemperatureStatsEvent();
}

class TemperatureStatsGet extends TemperatureStatsEvent {}

class TemperatureStatsRefresh extends TemperatureStatsEvent {}
