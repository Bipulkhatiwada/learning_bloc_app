import 'package:bloc/bloc.dart';
import 'package:learning_bloc_app/bloc/counter/counter_event.dart';
import 'package:learning_bloc_app/bloc/counter/counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState()) {
    // Pass an initial value for counter
    on<IncrementCounter>(_increment);
    on<DecrementCounter>(_decrement);
    on<ResetCounter>(_restCounter);
  }

  void _increment(IncrementCounter event, Emitter<CounterState> emit) {
    // Add your increment logic here
    emit(state.copyWith(counter: state.counter + 1));
  }

  void _decrement(DecrementCounter event, Emitter<CounterState> emit) {
    // Add your increment logic here
    if (state.counter > 0) {
      emit(state.copyWith(counter: state.counter - 1));
      emit(state.copyWith(message: ""));
    } else {
      emit(state.copyWith(message: "counter cannot be less than 0"));
    }
  }

  void _restCounter(ResetCounter event, Emitter<CounterState> emit) {
    // Add your increment logic here
    emit(state.copyWith(counter: 0));
  }
}
