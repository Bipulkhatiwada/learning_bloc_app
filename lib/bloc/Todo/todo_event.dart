import 'package:equatable/equatable.dart';

class TodoEvent extends Equatable{

const TodoEvent();

@override
List<Object?> get props => [];

}

class AddToDoEvent extends TodoEvent {

  final String title;
   final String desc;

  AddToDoEvent({required this.title, required this.desc });

  @override
  List<Object> get props => [title, desc];
}

class DeleteTodoEvent extends TodoEvent { 

  final int itemIndex;

  DeleteTodoEvent({required this.itemIndex});

  @override
  List<Object> get props => [itemIndex];
}