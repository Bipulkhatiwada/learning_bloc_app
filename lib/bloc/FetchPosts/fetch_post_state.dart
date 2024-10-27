import 'package:equatable/equatable.dart';
import 'package:learning_bloc_app/Utils/enums.dart';
import 'package:learning_bloc_app/models/PostModel.dart';

class FetchPostState extends Equatable {
  final PostStatus postStatus;
  final List<PostModel> postList;
  final String message;

  const FetchPostState({
    this.postStatus = PostStatus.loading,
    this.postList = const <PostModel>[],
    this.message = "",
  });

  FetchPostState copyWith({
    PostStatus? postStatus,
    List<PostModel>? postList,
    String? message,
  }) {
    return FetchPostState(
      postStatus: postStatus ?? this.postStatus,
      postList: postList ?? this.postList,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [postStatus, postList, message];
}
