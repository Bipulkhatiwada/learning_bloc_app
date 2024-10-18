import 'package:flutter/material.dart';
import 'package:learning_bloc_app/bloc/Calculator/calculator_bloc.dart';
import 'package:learning_bloc_app/bloc/Calculator/calculator_event.dart';
import 'package:learning_bloc_app/bloc/Calculator/calculator_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Calculator extends StatefulWidget {
  final String title;

  const Calculator({super.key, required this.title});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final List<String> buttons = [
    '1', '2', '3', '+',
    '4', '5', '6', '*',
    '7', '8', '9', '/',
    'C', '0', '-', '=', '<-'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<CalculatorBloc, CalculatorBlocState>(
          builder: (context, state) {
            return Column(
              children: [
                _buildDisplayView(
                  operand1: state.operand1?.toString() ?? "",
                  operator: state.operator ?? "",
                  operand2: state.operand2?.toString() ?? "",
                  output: state.outPut?.toString() ?? "",
                ),
                const SizedBox(height: 20),
                Expanded(child: _buildButtonGrid()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDisplayView({
    required String operand1,
    required String operator,
    required String operand2,
    required String output,
  }) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            Text(
              "$operand1 $operator $operand2",
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Row(
          children: [
            const Spacer(),
            Text(
              output.isNotEmpty ? output : "",
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        return _buildButton(label: buttons[index]);
      },
    );
  }

  Widget _buildButton({required String label}) {
    return GestureDetector(
      onTap: () {
        if (label == '=') {
          final state = context.read<CalculatorBloc>().state;
          switch (state.operator) {
            case '+':
              context.read<CalculatorBloc>().add(AddEvent());
              break;
            case '-':
              context.read<CalculatorBloc>().add(SubtractEvent());
              break;
            case '*':
              context.read<CalculatorBloc>().add(MultiplyEvent());
              break;
            case '/':
              context.read<CalculatorBloc>().add(DivideEvent());
              break;
          }
        } else if (label == 'C') {
          context.read<CalculatorBloc>().add(ClearEvent());
        } else if (label == '<-') {
          context.read<CalculatorBloc>().add(DeleteEvent());
        }else {
          context.read<CalculatorBloc>().add(InputEvent(input: label));
        }
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 75, 88, 97),
            ),
          ),
        ),
      ),
    );
  }
}
