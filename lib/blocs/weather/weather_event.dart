part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class FetchWeatherEvent extends WeatherEvent {
  // event 시 param으로 받을 정보를 선언하고
  final String city;
  // 생성자에서 해당 정보를 전달받음.
  const FetchWeatherEvent({required this.city});
}
