import 'package:equatable/equatable.dart';

class TodoEvent extends Equatable{

const TodoEvent();

@override
List<Object?> get props => [];

}

class AddToDoEvent extends TodoEvent {

  final String title;
   final String desc;

  const AddToDoEvent({required this.title, required this.desc });

  @override
  List<Object> get props => [title, desc];
}

class DeleteTodoEvent extends TodoEvent { 

  final int itemIndex;

  const DeleteTodoEvent({required this.itemIndex});

  @override
  List<Object> get props => [itemIndex];
}

class FetchListEvent extends TodoEvent {}

class ResetTodoEvent extends TodoEvent {}

class UpdateTodoEvent extends TodoEvent {


  final int itemIndex;
  final String title;
  final String desc;

  const UpdateTodoEvent({required this.itemIndex, required this.title, required this.desc});

  @override
  List<Object> get props => [itemIndex, title, desc];
}