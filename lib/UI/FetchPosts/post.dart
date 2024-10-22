import 'package:flutter/material.dart';
import 'package:learning_bloc_app/UI/SharedUi/post_card.dart';
import 'package:learning_bloc_app/Utils/enums.dart';
import 'package:learning_bloc_app/bloc/FetchPosts/fetch_post_bloc.dart';
import 'package:learning_bloc_app/bloc/FetchPosts/fetch_post_event.dart';
import 'package:learning_bloc_app/bloc/FetchPosts/fetch_post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc_app/models/PostModel.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key, required this.title});

  final String title;

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FetchPostsBloc>().add(FetchPosts()); // Trigger event to fetch posts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
        elevation: 4.0, // Add elevation to the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<FetchPostsBloc, FetchPostState>(
          builder: (context, state) {
            switch (state.postStatus) {
              case PostStatus.loading:
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.blueAccent,
                        strokeWidth: 4.0,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Loading posts...',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                );
              case PostStatus.failure:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Failed to load posts.',
                        style:  TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        state.message,
                        style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              case PostStatus.success:
                return ListView.builder(
                  itemCount: state.postList.length,
                  itemBuilder: (context, index) {
                    final List<PostModel> listToDisplay = state.postList;
                    final item = listToDisplay[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: PostCard(
                        postId: item.postId ?? 0,
                        id: item.id ?? 0,
                        name: item.name ?? "",
                        email: item.email ?? "",
                        body: item.body ?? "",
                      ),
                    );
                  },
                );
              default:
                return const Center(
                  child: Text('Unexpected state.'),
                );
            }
          },
        ),
      ),
    );
  }
}



