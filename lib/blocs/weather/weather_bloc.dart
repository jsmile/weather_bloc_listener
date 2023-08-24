import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/custom_error.dart';
import '../../models/weather.dart';
import '../../repositories/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  // 원격 날씨 정보( API Service ) 호출이 필요하므로 Repository 선언
  final WeatherRepository weatherRepository;
  // 정상적으로 생성된 Repository instance를 생성자의 param으로 전달받음.
  // UI에서 Repository 에 필요한 param 정보를 전달받아 생성.
  WeatherBloc({required this.weatherRepository})
      : super(WeatherState.initial()) {
    // EventHandler 선언 및 정의 : 상태변화 직접 반영( emit )
    // 일반함수 내에서 add( EventHandler ) 형식으로 상태변화 간접 반영 가능.
    on<FetchWeatherEvent>(_fetchWeather);
  }

  Future<void> _fetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    try {
      // API 의 호출 시작을 알림.
      emit(state.copyWith(status: WeatherStatus.loading));
      // event 를 통해 Repository 실행 --> API 의 호출
      final Weather weather = await weatherRepository.fetchWeather(event.city);
      // API 의 작업 완료를 알림
      emit(
        state.copyWith(
          weather: weather,
          status: WeatherStatus.loaded,
        ),
      );
      // API 의 작업중 Error 가 발생하면 Error 를 알림
    } on CustomError catch (e) {
      emit(
        state.copyWith(
          status: WeatherStatus.failure,
          error: e,
        ),
      );
    }
  }
}
