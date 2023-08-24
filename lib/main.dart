import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'blocs/blocs.dart';
import 'pages/home_page.dart';
import 'repositories/weather_repository.dart';
import 'services/weather_api_service.dart';

void main() async {
  ansiColorDisabled = false;
  // 환경변수 읽기
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider 에서 사용할 수 있도록 RepositoryProvider() 를 상위에 정의.
    return RepositoryProvider(
      create: (context) => WeatherRepository(
        weatherApiService: WeatherApiService(
          httpClient: http.Client(),
        ),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WeatherBloc>(
            create: (context) => WeatherBloc(
              weatherRepository: context.read<WeatherRepository>(),
            ),
          ),
          BlocProvider<TempSettingsBloc>(
            create: (context) => TempSettingsBloc(),
          ),
          BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc(),
          ),
        ],
        // 구독신청 했던 Bloc의 State 를 Listen 할 수 있도록 변환시키기 위해
        // BlocListener<xxxBloc, xxxState>() 로 감싸고,
        // listener 에서 원하는 상태변화를 처리함.
        child: BlocListener<WeatherBloc, WeatherState>(
          listener: (context, state) {
            // 아래처럼 Bloc 에서 처리할 수도 있고, UI의 이 위치에서 처리할 수도 있음.
            context.read<ThemeBloc>().changeTheme(state.weather.temp);
          },
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                title: 'Flutter BLoC - OpenWeather Bloc',
                debugShowCheckedModeBanner: false,
                theme:
                    // BlocBuilder<>() 가 context.watch<> 역할을 하므로 삭제
                    // context.watch<ThemeBloc>().state.appTheme == AppTheme.light
                    state.appTheme == AppTheme.light
                        ? ThemeData.light()
                        : ThemeData.dark(),
                home: const HomePage(),
              );
            },
          ),
        ),
      ),
    );
  }
}
