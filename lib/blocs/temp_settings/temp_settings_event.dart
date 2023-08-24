part of 'temp_settings_bloc.dart';

sealed class TempSettingsEvent extends Equatable {
  const TempSettingsEvent();

  @override
  List<Object> get props => [];
}

// 이벤트에 param 이 필요없으니 Event 만 선언함.
class ToggleTempUnitEvent extends TempSettingsEvent {}
