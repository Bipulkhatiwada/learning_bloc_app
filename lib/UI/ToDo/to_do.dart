import 'package:flutter/material.dart';
import 'package:learning_bloc_app/UI/ToDo/ToDoFormView.dart';
import 'package:learning_bloc_app/bloc/Todo/todo_bloc.dart';
import 'package:learning_bloc_app/bloc/Todo/todo_event.dart';
import 'package:learning_bloc_app/bloc/Todo/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key, required this.title});
  final String title;

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,

        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add_circle_rounded),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => ToDoFormScreen(title: 'Add Details'),
        //         ),
        //       );
        //     },
        //   ),
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ToDoFormScreen(title: 'Add Details'),
            ),
          );

          // Handle the result (if you passed a signal like true when adding a to-do)
          if (result == true) {
            setState(
                () {}); // Trigger a rebuild of the ToDoScreen after coming back
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Listen for any changes in TodoBloc and rebuild the UI if needed
            BlocListener<TodoBloc, TodoState>(
              listener: (context, state) {
                // This will automatically trigger rebuild on any state change
                setState(() {});
              },
              child: Expanded(
                child: BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    if (state.todoList == null || state.todoList!.isEmpty) {
                      return const Center(
                        child:
                            // OutlinedButton(
                            //   onPressed: () async {
                            //     final result = await Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) =>
                            //             ToDoFormScreen(title: 'Add Details'),
                            //       ),
                            //     );

                            //     // Handle the result (if you passed a signal like true when adding a to-do)
                            //     if (result == true) {
                            //       setState(
                            //           () {}); // Trigger a rebuild of the ToDoScreen after coming back
                            //     }
                            //   },
                            //   child: const Text('Add To DO'),
                            // )
                            Center(
                          child: Padding(
                            // Added padding
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.no_backpack_rounded,
                                    size: 48.0,
                                    color: Color.fromARGB(255, 234, 29, 2)), // Icon color for consistency
                                SizedBox(height: 12.0), // Slightly more spacing
                                Text(
                                  "No list data Available",
                                  style: TextStyle(
                                      fontWeight:
                                          FontWeight.bold), // Bolder text
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.todoList!.length,
                      itemBuilder: (context, index) {
                        final List<ListDataModel> listToDisplay = state.todoList!.reversed.toList();
                        final item = listToDisplay[index];
                        return _listItem(
                          context,
                          title: item.title ?? 'No Title',
                          description: item.description ?? 'No Description',
                          itemIndex: index,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _listItem(
  BuildContext context, {
  required String title,
  required String description,
  required int itemIndex,
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(description),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _showDeleteConfirmationDialog(context, itemIndex, title);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    ),
  );
}

void _showDeleteConfirmationDialog(
    BuildContext context, int itemIndex, String title) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete $title '),
        content: const Text('Are you sure you want to delete this To-DO item?'),
        actions: [
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Trigger the deletion of the item
              context
                  .read<TodoBloc>()
                  .add(DeleteTodoEvent(itemIndex: itemIndex));

              // Close the dialog
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
