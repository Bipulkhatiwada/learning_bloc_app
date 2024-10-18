import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc_app/bloc/switchEvents/switch_event_bloc.dart';
import 'package:learning_bloc_app/bloc/switchEvents/switch_event_event.dart';
import 'package:learning_bloc_app/bloc/switchEvents/switch_event_state.dart';

class SwitchExampleBlock extends StatefulWidget {
  const SwitchExampleBlock({super.key, required this.title});
  final String title;

  @override
  State<SwitchExampleBlock> createState() => SwitchExampleBlockState();
}

class SwitchExampleBlockState extends State<SwitchExampleBlock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSwitchCard(),
              const SizedBox(height: 20),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: _buildColoredContainer(),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Flexible(
                    flex: 8,
                    child: BlocBuilder<SwitchEventBloc, SwitchEventStates>(
                        builder: (context, state) {
                      return Slider(
                        value: state.sliderValue,
                        min: 0,
                        max: 100,
                        divisions: 10, // Adjust divisions for more granularity
                        label: state.sliderValue.round().toString(),
                        onChanged: (double value) {
                          context
                              .read<SwitchEventBloc>()
                              .add(SliderEvent(slider: value));
                        },
                      );
                    }),
                  ),
                  Flexible(
                    flex: 1,
                    child: BlocBuilder<SwitchEventBloc, SwitchEventStates>(
                        builder: (context, state) {
                      return Text(
                        state.sliderValue.round().toString(),
                        style: const TextStyle(fontSize: 16.0),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// Method to build the colored container based on slider value
Widget _buildColoredContainer() {
  return BlocBuilder<SwitchEventBloc, SwitchEventStates>(
     buildWhen: (previousState, currentState) {
    return previousState.sliderValue != currentState.sliderValue;
  },
    builder: (context, state) {
                print("colored container");

      return Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity((state.sliderValue / 100).clamp(0.0, 1.0)),
          borderRadius: BorderRadius.circular(state.sliderValue * 4), // Set corner radius
        ),
      );
    },
  );
}


  // Method to build the switch card
  Widget _buildSwitchCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      child: BlocBuilder<SwitchEventBloc, SwitchEventStates>(
         buildWhen: (previousState, currentState) {
          return previousState.isSwitchOn != currentState.isSwitchOn;
  },
        builder: (context, state) {
          print("switch card");
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  state.isSwitchOn ? "Disable Notifications" : "Enable Notifications",
                  style: const TextStyle(fontSize: 18.0),
                ),
                const Spacer(),
                Switch(
                  value: state.isSwitchOn,
                  onChanged: (newValue) {
                    // Dispatch the EnableOrDisableNotification event
                    context
                        .read<SwitchEventBloc>()
                        .add(EnableOrDisableNOtification());
                  },
                  activeColor: Colors.blueAccent,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}