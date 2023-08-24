import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'temp_settings_event.dart';
part 'temp_settings_state.dart';

class TempSettingsBloc extends Bloc<TempSettingsEvent, TempSettingsState> {
  // 자신의 State 변경에는 다른 Bloc 이 필요없으므로 param 불필요
  TempSettingsBloc() : super(TempSettingsState.initial()) {
    // Event Handler 등록 및 정의
    on<ToggleTempUnitEvent>(_toggleTempUnit);
  }

  // async 작업이 아니므로 Future<void> 불필요
  void _toggleTempUnit(
    ToggleTempUnitEvent event,
    Emitter<TempSettingsState> emit,
  ) {
    // 현재 settrings 상태에 따라 반대로 변경
    // EventHandler 안이므로 emit( State ) 형식으로 직접 반영
    emit(
      state.copyWith(
        tempUnit: state.tempUnit == TempUnit.celcius
            ? TempUnit.fahrenheit
            : TempUnit.celcius,
      ),
    );
  }
}
