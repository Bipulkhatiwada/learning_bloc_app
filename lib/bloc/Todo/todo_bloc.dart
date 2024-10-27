import 'package:bloc/bloc.dart';
import 'package:learning_bloc_app/Data/secure_storage.dart';
import 'package:learning_bloc_app/Utils/enums.dart';
import 'package:learning_bloc_app/Viewmodels/list_model.dart';
import 'package:learning_bloc_app/bloc/Todo/todo_event.dart';
import 'package:learning_bloc_app/bloc/Todo/todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoState()) {
    on<AddToDoEvent>(_addTodo);
    on<DeleteTodoEvent>(_deleteTodo);
    on<FetchListEvent>(_fetchTodoList);
    on<ResetTodoEvent>(_resetTodoEvent);
     on<UpdateTodoEvent>(_editTodo);
     on<CompleteTodoEvent>(_completeTodo);
  }

  void _addTodo(AddToDoEvent event, Emitter<TodoState> emit) {
    var todoList = List<ListDataModel>.from(state.todoList ?? []);
    todoList.add(ListDataModel(title: event.title, description: event.desc, todoStatus: TodoStatus.pending));
    SecureStorage().saveSecureData("toDoList", todoList);
    emit(state.copyWith(
        todoList: todoList,
        message: "Added successfully",
        postStatus: PostStatus.success));
  }

  void _fetchTodoList(FetchListEvent event, Emitter<TodoState> emit) async {
  emit(state.copyWith(todoList: [], postStatus: PostStatus.loading));
  await Future.delayed(const Duration(seconds: 2));
  var list = await SecureStorage().readSecureData("toDoList");
  emit(state.copyWith(todoList: list, postStatus: PostStatus.success));
}


  void _deleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    var list = await SecureStorage().readSecureData("toDoList");
    if (list != null && list.isNotEmpty) {
      if (event.itemIndex >= 0 && event.itemIndex < list.length) {
        list.removeAt(event.itemIndex);
      }
      SecureStorage().saveSecureData("toDoList", list);

      emit(state.copyWith(todoList: list, message: "deleted successfully"));
    }
  }

  void _editTodo(UpdateTodoEvent event, Emitter<TodoState> emit) async {
    var list = await SecureStorage().readSecureData("toDoList");
    if (list != null && list.isNotEmpty) {
      if (event.itemIndex >= 0 && event.itemIndex < list.length) {
      list[event.itemIndex] =  ListDataModel(title: event.title, description: event.desc, todoStatus: TodoStatus.pending);
      }
      SecureStorage().saveSecureData("toDoList", list);

      emit(state.copyWith(todoList: list, message: "edited successfully"));
    }
  }

   void _completeTodo(CompleteTodoEvent event, Emitter<TodoState> emit) async {
    var list = await SecureStorage().readSecureData("toDoList");
    if (list != null && list.isNotEmpty) {
      if (event.itemIndex >= 0 && event.itemIndex < list.length) {
      list[event.itemIndex] =  ListDataModel(title: event.title, description: event.desc, todoStatus: TodoStatus.completed);
      }
      SecureStorage().saveSecureData("toDoList", list);

      emit(state.copyWith(todoList: list, message: "edited successfully"));
    }
  }

  void _resetTodoEvent(ResetTodoEvent event, Emitter<TodoState> emit) async {
      emit(TodoState());
  }
}
