

import 'package:bloc/bloc.dart';
import 'package:learning_bloc_app/bloc/Calculator/calculator_event.dart';
import 'package:learning_bloc_app/bloc/Calculator/calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorBlocState> {
  CalculatorBloc() : super(CalculatorBlocState()) {
    on<AddEvent>(_add);
    on<SubtractEvent>(_subtract);
    on<MultiplyEvent>(_multiply);
    on<DivideEvent>(_divide);
    on<InputEvent>(_inputEvent);
    on<ClearEvent>(_clearEvent);
    on<DeleteEvent>(_deleteEvent);
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  // Function to extract components (first number, operator, second number)
  Map<String, String> extractComponents(List<String> input) {
    String firstNumber = '';
    String secondNumber = '';
    String operator = '';

    bool isOperatorFound = false;

    for (String item in input) {
      if (item == "+" || item == "-" || item == "*" || item == "/") {
        operator = item;
        isOperatorFound = true;
      } else {
        if (!isOperatorFound) {
          firstNumber += item;
        } else {
          secondNumber += item;
        }
      }
    }

    return {
      'firstNumber': firstNumber,
      'operator': operator,
      'secondNumber': secondNumber,
    };
  }

  // Addition
  void _add(AddEvent event, Emitter<CalculatorBlocState> emit) {
    final operand1 = state.operand1;
    final operand2 = state.operand2;

    if (operand1 != null && operand2 != null) {
      emit(state.copyWith(outPut: operand1 + operand2));
    }
  }

  // Subtraction
  void _subtract(SubtractEvent event, Emitter<CalculatorBlocState> emit) {
    final operand1 = state.operand1;
    final operand2 = state.operand2;

    if (operand1 != null && operand2 != null) {
      emit(state.copyWith(outPut: operand1 - operand2));
    }
  }

  // Multiplication
  void _multiply(MultiplyEvent event, Emitter<CalculatorBlocState> emit) {
    final operand1 = state.operand1;
    final operand2 = state.operand2;

    if (operand1 != null && operand2 != null) {
      emit(state.copyWith(outPut: operand1 * operand2));
    }
  }

  // Division
  void _divide(DivideEvent event, Emitter<CalculatorBlocState> emit) {
    final operand1 = state.operand1;
    final operand2 = state.operand2;

    if (operand1 != null && operand2 != null && operand2 != 0) {
      emit(state.copyWith(outPut: operand1 ~/ operand2));
    } else {
      // Handle division by zero
      emit(state.copyWith(outPut: null));
    }
  }

  // Input Event
  void _inputEvent(InputEvent event, Emitter<CalculatorBlocState> emit) {
    final stack = state.operationStack ?? [];

    // Handle numeric and operator input
    if (isNumeric(event.input)) {
      stack.add(event.input);
      Map<String, String> result = extractComponents(stack);

      emit(state.copyWith(
        operand1: int.tryParse(result['firstNumber']!),
        operand2: int.tryParse(result['secondNumber']!),
        operator: result['operator'],
        operationStack: stack,
      ));
    } else {
      stack.add(event.input);
      emit(state.copyWith(operator: event.input, operationStack: stack));
    }


  // if (!isNumeric(event.input)) {
    //   emit(state.copyWith(operator: event.input));
    // } else {
    //   if (state.operand1 == null) {
    //     emit(state.copyWith(operand1: int.tryParse(event.input)));
    //   } else {
    //     emit(state.copyWith(operand2: int.tryParse(event.input)));
    //   }
    // }
  }

   // Clear Event
  void _clearEvent(ClearEvent event, Emitter<CalculatorBlocState> emit) {
    emit(CalculatorBlocState());  // Reset the state
  }


  void _deleteEvent(DeleteEvent event, Emitter<CalculatorBlocState> emit) {
        // emit(CalculatorBlocState());  // Reset the state

  // Make a copy of the current stack
  final stack = List<String>.from(state.operationStack ?? []);

  // Check if the stack is not empty before removing the last item
  if (stack.isNotEmpty) {
    stack.removeLast();  // Removes the last item
  }

  // Update the state with the new stack
  Map<String, String> result = extractComponents(stack);

      emit(state.copyWith(
        operand1: int.tryParse(result['firstNumber']!),
        operand2: int.tryParse(result['secondNumber']!),
        operator: result['operator'],
        operationStack: stack,
      ));
}

}
