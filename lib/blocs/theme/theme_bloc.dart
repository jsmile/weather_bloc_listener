import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '/constants/constants.dart';

part 'theme_event.dart';
part 'theme_state.dart';

// 참조 Bloc 및 StreamSubscription 과 관련된 것들을 모두 지우고
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    // EventHandler 등록 및 정의
    on<ChangeThemeEvent>((event, emit) {
      // EventHandler 안이므로 emit( State ) 형식으로 직접 반영
      // event param 사용 가능
      emit(state.copyWith(appTheme: event.appTheme));
    });
  }

  // StreamScubcritpiton 의 stream.listen 에서 했던 작업을 함수로 변환
  // 날씨의 온도를 받아서 온도에 따라서 AppTheme 을 변경하는 함수
  void changeTheme(double temperture) {
    if (temperture > kWarmOrNot) {
      // EventHandler 안이 아니므로 add( Event() ) 형식으로 호출
      add(const ChangeThemeEvent(appTheme: AppTheme.light));
    } else {
      add(const ChangeThemeEvent(appTheme: AppTheme.dark));
    }
  }
}
