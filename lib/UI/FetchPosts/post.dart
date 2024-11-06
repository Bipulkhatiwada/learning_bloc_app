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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FetchPostsBloc>().add(FetchPosts()); // Trigger event to fetch posts
  }
   @override
  void dispose() {
    nameController.dispose();
    bodyController.dispose();
    super.dispose();
  }

 void _showAddPostDialog() {
  // Clear the text fields before showing the dialog
  nameController.clear();
  bodyController.clear();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add New Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: bodyController,
              decoration: const InputDecoration(
                labelText: 'Body',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<FetchPostsBloc>().add(AddPost(
                title: nameController.text,
                desc: bodyController.text,
              ));
              Navigator.of(context).pop(); // Dismiss the dialog
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
        elevation: 4.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddPostDialog, // Show the dialog on button click
          ),
        ],
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
                        style: TextStyle(
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
                        postId: item.postId ?? "",
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
