import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc_app/bloc/FetchPosts/fetch_post_bloc.dart';
import 'package:learning_bloc_app/bloc/FetchPosts/fetch_post_event.dart';
import 'package:learning_bloc_app/bloc/FetchPosts/fetch_post_state.dart';

class PostCard extends StatefulWidget {
  final String postId;
  final String name;
  final String email;
  final String body;

  const PostCard({
    super.key,
    required this.postId,
    required this.name,
    required this.email,
    required this.body,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchPostsBloc, FetchPostState>(
        builder: (context, state) {
      return Card(
        elevation: 3.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post Header (Name & Email)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      widget.email,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Post Body
              Text(
                widget.body,
                style: const TextStyle(fontSize: 14.0),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              // Post Footer (Post ID and Buttons)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Post ID
                  Text(
                    'Post ID: ${widget.postId}',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                  // Action Buttons
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditPostDialog();
                        },
                        tooltip: 'Edit Post',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeletePostDialog();
                        },
                        tooltip: 'Delete Post',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showEditPostDialog() {
    // Clear the text fields before showing the dialog
    nameController.text = widget.name;
    bodyController.text = widget.body;

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
                Navigator.of(context).pop(); // Dismiss the dialog

                context.read<FetchPostsBloc>().add(EditPost(
                      postId: widget.postId,
                      title: nameController.text,
                      desc: bodyController.text,
                    ));
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showDeletePostDialog() {
    // Clear the text fields before showing the dialog
    nameController.clear();
    bodyController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Post'),
          content: const Text("are you sure you want to delete???"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                context
                    .read<FetchPostsBloc>()
                    .add(DeletePost(postId: widget.postId));
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
