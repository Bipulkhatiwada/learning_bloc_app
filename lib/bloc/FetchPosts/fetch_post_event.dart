
import 'package:equatable/equatable.dart';

class FetchPostEvent extends Equatable {

const FetchPostEvent();


@override
 List<Object> get props => [];

}

class FetchPosts extends FetchPostEvent {}


class AddPost extends FetchPostEvent {

  final String title;
  final String desc;

  const AddPost({required this.title, required this.desc});

  @override
  List<Object> get props => [title, desc];
}

class EditPost extends FetchPostEvent {

  final String title;
  final String desc;
  final String postId;

  const EditPost({required this.title, required this.desc, required this.postId});

  @override
  List<Object> get props => [title, desc, postId];
}

class DeletePost extends FetchPostEvent {

  final String postId;

  const DeletePost({required this.postId});

  @override
  List<Object> get props => [ postId];
}