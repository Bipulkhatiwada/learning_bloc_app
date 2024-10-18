import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class CalculatorBlocState extends Equatable {
  List<String>? operationStack = [];
  final int? operand1;
  final String? operator;
  final int? operand2;
  final int? outPut;

  CalculatorBlocState({
    this.operand1,
    this.operator,
    this.operand2,
    this.outPut,
    this.operationStack,
  });

  CalculatorBlocState copyWith({
    int? operand1,
    String? operator,
    int? operand2,
    int? outPut,
    List<String>? operationStack,
  }) {
    return CalculatorBlocState(
      operand1: operand1 ?? this.operand1,
      operator: operator ?? this.operator,
      operand2: operand2 ?? this.operand2,
      outPut: outPut ?? this.outPut,
      operationStack: operationStack ?? this.operationStack,
    );
  }

  @override
  List<Object?> get props => [operand1, operator, operand2, outPut];
}
