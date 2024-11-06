import 'package:bloc/bloc.dart';
import 'package:learning_bloc_app/Network/dio_client.dart';
import 'package:learning_bloc_app/Repository/post_repository.dart';
import 'package:learning_bloc_app/Utils/enums.dart';
import 'package:learning_bloc_app/bloc/FetchPosts/fetch_post_event.dart';
import 'package:learning_bloc_app/bloc/FetchPosts/fetch_post_state.dart';
import 'package:learning_bloc_app/models/PostModel.dart';

class FetchPostsBloc extends Bloc<FetchPostEvent, FetchPostState> {
  PostRepository postRepository = PostRepository();
  FetchPostsBloc() : super(const FetchPostState()) {
    on<FetchPosts>(fetchPost);
    on<AddPost>(addPost);
    on<EditPost>(editPost);
    on<DeletePost>(deletePost);
  }

  void fetchPost(FetchPosts event, Emitter<FetchPostState> emit) async {
    final DioClient dioClient = DioClient();
    await dioClient.fetchPost().then((newValue) {
      emit(state.copyWith(
        postStatus: PostStatus.success,
        message: "",
        postList: newValue,
      ));
    }).onError((error, stackTrace) {
      emit(state.copyWith(
          postStatus: PostStatus.failure, message: error.toString()));
    });

    // await postRepository.fetchPost().then((newValue)  {
    //     emit(state.copyWith(
    //       postStatus: PostStatus.success,
    //       message: "",
    //       postList: newValue,
    //       ));
    // }).onError((error, stackTrace){
    //     emit(state.copyWith(postStatus: PostStatus.failure, message: error.toString()));
    // });
  }

  void addPost(AddPost event, Emitter<FetchPostState> emit) async {
    final listModel =
        PostModel(name: event.title, body: event.desc);
    final DioClient dioClient = DioClient();
    await dioClient.postData(list: listModel).then((newValue) {
      add(FetchPosts());
    }).onError((error, stackTrace) {
      emit(state.copyWith(
          postStatus: PostStatus.failure, message: error.toString()));
    });
  }

  void editPost(EditPost event, Emitter<FetchPostState> emit) async {
    final listModel =
        PostModel(name: event.title, body: event.desc, postId: event.postId);
    final DioClient dioClient = DioClient();
    await dioClient.editData(list: listModel).then((newValue) {
      add(FetchPosts());
    }).onError((error, stackTrace) {
      emit(state.copyWith(
          postStatus: PostStatus.failure, message: error.toString()));
    });
  }

  void deletePost(DeletePost event, Emitter<FetchPostState> emit) async {
   
    final DioClient dioClient = DioClient();
    await dioClient.deleteData(id: event.postId).then((newValue) {
      add(FetchPosts());
    }).onError((error, stackTrace) {
      emit(state.copyWith(
          postStatus: PostStatus.failure, message: error.toString()));
    });
  }
}
