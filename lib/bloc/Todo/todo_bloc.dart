import 'package:bloc/bloc.dart';
import 'package:learning_bloc_app/bloc/Todo/todo_event.dart';
import 'package:learning_bloc_app/bloc/Todo/todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoState()) {
    on<AddToDoEvent>(_addTodo);
    on<DeleteTodoEvent>(_deleteTodo);
  }

  void _addTodo(AddToDoEvent event, Emitter<TodoState> emit) {
    // Initialize the todoList if it's null
    var todoList = List<ListDataModel>.from(state.todoList ?? []);
    todoList.add(ListDataModel(title: event.title, description: event.desc));
    emit(state.copyWith(todoList: todoList));
  }

  void _deleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) {
    var todoList = List<ListDataModel>.from(state.todoList ?? []);
    if (event.itemIndex >= 0 && event.itemIndex < todoList.length) {
      todoList.removeAt(event.itemIndex);
    }
    emit(state.copyWith(todoList: todoList));  
  }
}
