import 'package:bloc/bloc.dart';
import 'package:learning_bloc_app/Repository/post_repository.dart';
import 'package:learning_bloc_app/Utils/enums.dart';
import 'package:learning_bloc_app/bloc/FetchPosts/fetch_post_event.dart';
import 'package:learning_bloc_app/bloc/FetchPosts/fetch_post_state.dart';


class FetchPostsBloc extends Bloc<FetchPostEvent, FetchPostState> {
 PostRepository postRepository = PostRepository();
  FetchPostsBloc() : super(const FetchPostState()){
     on<FetchPosts>(fetchPost);
  }

  void fetchPost(FetchPosts event,  Emitter<FetchPostState> emit) async {
    await postRepository.fetchPost().then((newValue)  {
        emit(state.copyWith(
          postStatus: PostStatus.success, 
          message: "",
          postList: newValue,
          ));
    }).onError((error, stackTrace){
        emit(state.copyWith(postStatus: PostStatus.failure, message: error.toString()));
    });
    }
}