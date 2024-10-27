// ignore: file_names
import 'package:flutter/material.dart';
import 'package:learning_bloc_app/bloc/Todo/todo_bloc.dart';
import 'package:learning_bloc_app/bloc/Todo/todo_event.dart';
import 'package:learning_bloc_app/bloc/Todo/todo_state.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';

class ToDoFormScreen extends StatelessWidget {
  final String? title;
  final String? desc;
  final String? type;
  final int itemIndex;

  const ToDoFormScreen(
      {super.key, this.title, this.desc, this.type, required this.itemIndex});

  @override
  Widget build(BuildContext context) {
    print("*********list form view build*********");
    print("*********$title, $desc, $type *********");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<TodoBloc, TodoState>(
                builder: (context, state) {
                  return _todoForm(context, title, desc, type, itemIndex);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _todoForm(BuildContext context, String? title, String? desc,
    String? type, int itemIndex) {
  String todoTitle = title ?? "";
  String todoDesc = desc ?? "";

  TextEditingController titleController = TextEditingController(text: title);
  TextEditingController descriptionController =
      TextEditingController(text: desc);

  void showSnackBar(BuildContext context, String message) {
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
      padding: const EdgeInsets.all(8.0),
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
                            controller: titleController,
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
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Enter Description',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              todoDesc = value;
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: () {
                              if (type == "edit") {
                                context.read<TodoBloc>().add(UpdateTodoEvent(
                                    itemIndex: itemIndex,
                                    title: todoTitle ,
                                    desc: todoDesc ));
                                Navigator.pop(context, true);
                              } else {
                                if (todoTitle != "" && todoDesc != "") {
                                  context.read<TodoBloc>().add(AddToDoEvent(
                                      title: todoTitle, desc: todoDesc));
                                  Navigator.pop(context, true);
                                } else {
                                  showSnackBar(
                                      context, "Fields Cannot be empty");
                                }
                              }
                            },
                            child: const Text('Add To Do'),
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
