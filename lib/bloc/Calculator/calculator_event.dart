import 'package:equatable/equatable.dart';

class CalculatorEvent extends Equatable {
  const CalculatorEvent();

  @override
  List<Object> get props => [];
}

class AddEvent extends CalculatorEvent {}

class SubtractEvent extends CalculatorEvent {}

class MultiplyEvent extends CalculatorEvent {}

class DivideEvent extends CalculatorEvent {}

class InputEvent extends CalculatorEvent {
  final String input;

  InputEvent({required this.input});

  @override
  List<Object> get props => [input];
}

class ClearEvent extends CalculatorEvent {}

class DeleteEvent extends CalculatorEvent {}
