import 'package:flutter/material.dart';
import 'package:learning_bloc_app/UI/ToDo/ToDoFormView.dart';
import 'package:learning_bloc_app/Utils/enums.dart';
import 'package:learning_bloc_app/Viewmodels/list_model.dart';
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
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(FetchListEvent());
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    print("########list view build#######");
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  const ToDoFormScreen(itemIndex: 0),
            ),
          );

          // if (result == true) {
          //   setState(() {});
          // }
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
                if (state.message != "" && state.message != null) {
                  _showSnackBar(context, state.message.toString());
                }
                setState(() {});
              },
              child: Expanded(
                child: BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    if (state.postStatus == PostStatus.loading) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CircularProgressIndicator(
                              color: Colors.blueAccent,
                              strokeWidth: 4.0,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Loading list...',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      );
                    } else if (state.postStatus == PostStatus.success) {
                      if (state.todoList == null || state.todoList!.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.no_backpack_rounded,
                                  size: 48.0,
                                  color: Color.fromARGB(255, 234, 29, 2),
                                ),
                                SizedBox(height: 12.0),
                                Text(
                                  "No list data Available",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: state.todoList!.length,
                        itemBuilder: (context, index) {
                          final List<ListDataModel> listToDisplay =
                              state.todoList!.toList();
                          final item = listToDisplay[index];
                          return _listItem(context,
                              title: item.title ?? 'No Title',
                              description: item.description ?? 'No Description',
                              itemIndex: index,
                              count: state.todoList!.length);
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                  buildWhen: (previousState, currentState) {
                    return previousState.todoList != currentState.todoList;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    context.read<TodoBloc>().add(ResetTodoEvent());
  }
}

Widget _listItem(BuildContext context,
    {required String title,
    required String description,
    required int itemIndex,
    required int count}) {
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
              _showDeleteConfirmationDialog(
                  context, itemIndex, title, description, count, "delete");
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              // _showDeleteConfirmationDialog(
              //     context, itemIndex, title, description, count, "edit");
               Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ToDoFormScreen(title: title, desc: description, type: "edit", itemIndex: itemIndex),
                  ),
                );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    ),
  );
}

void _showDeleteConfirmationDialog(BuildContext context, int itemIndex,
    String title, String desc, int count, String type) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete $title '),
        content: Text('Are you sure you want to $type this To-DO item?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            onPressed: () {
              if (type == "delete") {
                context
                    .read<TodoBloc>()
                    .add(DeleteTodoEvent(itemIndex: itemIndex));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ToDoFormScreen(title: title, desc: desc, type: type, itemIndex: itemIndex),
                  ),
                );
              }
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
