import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class TodoState extends Equatable {
  List<ListDataModel>? todoList = [];

  TodoState({
    this.todoList,
  });

  TodoState copyWith ({
    List<ListDataModel>? todoList,
  }) {
    return  TodoState (todoList: todoList ?? this.todoList);
  }

  @override
  List<Object?> get props => [todoList];
}

// ignore: must_be_immutable
class ListDataModel extends Equatable {
  String? title;
  String? description;
  String? icon;

  ListDataModel({this.title, this.description, this.icon});

  ListDataModel copyWith({
    String? title,
    String? description,
    String? icon,
  }) {
    return ListDataModel(  
    title: title ?? this.title,
    description: description ?? this.description,
    icon: icon ?? this.icon,
    );
   
  }

  @override
  List<Object?> get props => [title, description, icon];
}
