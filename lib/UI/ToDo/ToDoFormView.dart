import 'package:flutter/material.dart';
import 'package:learning_bloc_app/bloc/Todo/todo_bloc.dart';
import 'package:learning_bloc_app/bloc/Todo/todo_event.dart';
import 'package:learning_bloc_app/bloc/Todo/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToDoFormScreen extends StatefulWidget {
  const ToDoFormScreen({super.key, required this.title});

  final String title;

  @override
  State<ToDoFormScreen> createState() => _ToDoFormScreenState();
}

class _ToDoFormScreenState extends State<ToDoFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<TodoBloc, TodoState>(
                builder: (context, state) {
                  return _todoForm(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}

Widget _todoForm(BuildContext context) {
 String todoTitle = "";
 String desc = "";
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
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16), // Optional: Rounded corners
    ),
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            // Use Expanded to make the text column take only the needed space
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the leading side
              mainAxisSize: MainAxisSize
                  .min, // Prevent the column from taking all available height
              children: [
                BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
                  return Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Enter title',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                                todoTitle = value;
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Enter Description',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              desc = value;
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: () {
                              if (todoTitle != "" && desc != ""){
                               context.read<TodoBloc>().add(AddToDoEvent(title: todoTitle, desc: desc));
                               Navigator.pop(context, true); 
                              } else {
                                _showSnackBar(context, "Fields Cannot be empty");
                              }
                            },
                            child: const Text('Add To DO'),
                          ))
                    ],
                  );
                })
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

