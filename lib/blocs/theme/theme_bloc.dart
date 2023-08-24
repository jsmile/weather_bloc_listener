import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '/blocs/blocs.dart';
import '/constants/constants.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  // 온도 정보를 받아서 그에 따라 Theme 를 변경해야 하므로
  // 참조할 Bloc 와 StreamSubscription 선언
  final WeatherBloc weatherBloc;
  // 생성자 함수의 body 에서 초기화할 것이므로 late 선언
  late final StreamSubscription weatherBlocSubscription;

  ThemeBloc({
    required this.weatherBloc,
  }) : super(ThemeState.initial()) {
    // 참조할 Bloc 의 State 에 구독신청을 하고
    weatherBlocSubscription = weatherBloc.stream.listen(
      (WeatherState state) {
        // 참조한 Bloc 의 State 가 변경되면 변경 내용을 반영
        // EventHandler 안이 아니므로 add( Event ) 형식으로 반영
        if (state.weather.temp > kWarmOrNot) {
          add(const ChangeThemeEvent(appTheme: AppTheme.light));
        } else {
          add(const ChangeThemeEvent(appTheme: AppTheme.dark));
        }
      },
    );

    // EventHandler 등록 및 정의
    on<ChangeThemeEvent>((event, emit) {
      // EventHandler 안이므로 emit( State ) 형식으로 직접 반영
      // event param 사용 가능
      emit(state.copyWith(appTheme: event.appTheme));
    });
  }

  // 참조한 Bloc 의 State 에 구독신청을 해제
  @override
  Future<void> close() {
    weatherBlocSubscription.cancel();
    return super.close();
  }
}
