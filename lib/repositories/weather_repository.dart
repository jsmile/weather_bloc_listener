import 'package:flutter/material.dart';

import '/exceptions/weather_exception.dart';
import '/models/custom_error.dart';
import '/models/weather.dart';
import '/services/weather_api_service.dart';

import '/models/direct_geocoding.dart';
import '/utils/ansi_color.dart';

/// Repository 는 async 작업인 원격 Data 인 API 호출이나 원격 DB 사용 시 사용함.
/// 특히 복수개의 API 를 복합하여 사용하는 경우에 좋음( API Service 추상화 ).
/// UI 에서는 RepositoryProvider() 를 사용하여 호출함.
class WeatherRepository {
  final WeatherApiService weatherApiService;

  WeatherRepository({required this.weatherApiService});

  @override
  String toString() =>
      'WeatherRepository(weatherApiService: $weatherApiService)';

  Future<Weather> fetchWeather(String city) async {
    try {
      final DirectGeocoding directGeocoding =
          await weatherApiService.getDirectGeocoding(city);
      // print('### DirectGeocoding: $directGeocoding');
      debugPrint(info('### DirectGeocoding: $directGeocoding'));

      final Weather tempWeather =
          await weatherApiService.getWeather(directGeocoding);
      // print('### tempWeather: $tempWeather');
      debugPrint(info('### tempWeather: $tempWeather'));

      //getDirectGeocoding() 지역명과 getWeather() 의 지역명이 다를 수 있어서
      //name 과 country 등을 directGeocoding 의 항목으로 변경함.
      final Weather weather = tempWeather.copyWith(
        name: directGeocoding.name,
        country: directGeocoding.country,
        state: directGeocoding.state,
      );
      // print('### weather: $weather');
      // debugPrint(success('### weather: $weather'));

      return weather;
    } on WeatherException catch (e) {
      throw CustomError(errMag: e.message);
    } catch (e) {
      throw CustomError(errMag: e.toString());
    }
  }
}
