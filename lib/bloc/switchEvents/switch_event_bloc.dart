import 'package:bloc/bloc.dart';
import 'package:learning_bloc_app/bloc/switchEvents/switch_event_event.dart';
import 'package:learning_bloc_app/bloc/switchEvents/switch_event_state.dart';

class SwitchEventBloc extends Bloc<SwitchEvent, SwitchEventStates> {
  SwitchEventBloc() : super(SwitchEventStates()) {
    on<EnableOrDisableNOtification>(_enableOrDisableNotification);
    on<SliderEvent>(_sliderValueChange);
  }

  void _enableOrDisableNotification(
      EnableOrDisableNOtification event, Emitter<SwitchEventStates> emit) {
      emit(state.copyWith(isSwitchOn: !state.isSwitchOn));
  }
  void _sliderValueChange(
      SliderEvent event, Emitter<SwitchEventStates> emit) {
      emit(state.copyWith(sliderValue: event.slider));
  }
}
