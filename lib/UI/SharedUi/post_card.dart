import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  const PostCard({
    super.key,
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
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
                Expanded( // Wrap in Expanded to prevent overflow
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    overflow: TextOverflow.ellipsis, // Truncate if too long
                  ),
                ),
                const SizedBox(width: 8.0), // Small spacing
                Expanded( // Wrap in Expanded to prevent overflow
                  child: Text(
                    email,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis, // Truncate if too long
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Post Body (Body Content)
            Text(
              body,
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 10),
            // Post Footer (Post ID and ID)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Post ID: $postId',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'ID: $id',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}