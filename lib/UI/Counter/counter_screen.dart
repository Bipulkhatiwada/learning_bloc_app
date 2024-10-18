import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc_app/bloc/counter/counter_bloc.dart';
import 'package:learning_bloc_app/bloc/counter/counter_state.dart';
import 'package:learning_bloc_app/bloc/counter/counter_event.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            final screenWidth = MediaQuery.of(context).size.width;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCounterText(state.counter.toString(), screenWidth),
                const SizedBox(height: 20),
                _buildActionButtons(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCounterText(String counterValue, double screenWidth) {
    return Text(
      counterValue,
      style: TextStyle(
        fontSize: screenWidth * 0.15,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
        fontStyle: FontStyle.italic,
        decoration: TextDecoration.underline,
        decorationColor: const Color.fromARGB(255, 76, 238, 36),
        decorationStyle: TextDecorationStyle.dashed,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, CounterState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          context,
          onPressed: () {
            context.read<CounterBloc>().add(DecrementCounter());
            if (state.message != ""){
            _showSnackBar(context, state.message);
            }
          },
          label: "Decrease",
        ),
        const SizedBox(width: 16),
        _buildActionButton(
          context,
          onPressed: () {
            context.read<CounterBloc>().add(ResetCounter());
            _showSnackBar(context, "Reset to 0!");
          },
          label: "Reset ${state.counter}", 
        ),
        const SizedBox(width: 16),
        _buildActionButton(
          context,
          onPressed: () {
            context.read<CounterBloc>().add(IncrementCounter());
          },
          label: "Increase",
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, {
    required VoidCallback onPressed, 
    required String label
  }) {
    return Flexible(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Handle the action or dismiss
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}