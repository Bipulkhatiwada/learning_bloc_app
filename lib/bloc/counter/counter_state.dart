
// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';

class CounterState extends Equatable {
  final int counter;
final String message;
  const CounterState({
    this.counter = 0,
    this.message = "",
    });

  CounterState copyWith({int? counter, String? message}) {
    return CounterState(
      counter: counter ?? this.counter,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [counter];
}