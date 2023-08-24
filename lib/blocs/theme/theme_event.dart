part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ChangeThemeEvent extends ThemeEvent {
  // Theme 를 변경시킬 값을 .
  final AppTheme appTheme;
  // 생성자 함수의 param 으로 받아 초기화시킴.
  const ChangeThemeEvent({required this.appTheme});
}
