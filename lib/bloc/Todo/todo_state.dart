import 'package:equatable/equatable.dart';
import 'package:learning_bloc_app/Utils/enums.dart';
import 'package:learning_bloc_app/Viewmodels/list_model.dart';

// ignore: must_be_immutable
class TodoState extends Equatable {
  
  List<ListDataModel>? todoList = [];
  String? message = "";
  final PostStatus? postStatus;
  final TodoStatus? todoStatus;

  TodoState({
    this.todoList,
    this.message,
    this.postStatus,
    this.todoStatus,
  });

  TodoState copyWith ({
    List<ListDataModel>? todoList,
    String? message,
    PostStatus? postStatus,
    TodoStatus? todoStatus
  }) {
    return  TodoState (
      todoList: todoList ?? this.todoList,
      message: message ?? this.message,
      postStatus: postStatus ?? this.postStatus,
      todoStatus: todoStatus ?? this.todoStatus,
      );
  }

  @override
  List<Object?> get props => [todoList, message, postStatus, todoStatus];
}
