import 'dart:async';
import 'dart:convert';

import 'package:learning_bloc_app/models/PostModel.dart';
import 'package:http/http.dart' as http;

class PostRepository {
  Future<List<PostModel>> fetchPost() async {
    try {
      final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts/1/comments"));

      if (response.statusCode == 200) {
        final body = json.decode(response.body.toString()) as List;

        // Map the response to PostModel list
        return body.map((responseData) {
          return PostModel(
            postId: responseData['postId'],
            id: responseData['id'],
            name: responseData['name'],
            email: responseData['email'],
            body: responseData['body'],
          );
        }).toList();
      } else {
        throw Exception("Failed to load posts");
      }
    } on TimeoutException {
      throw Exception("Request Timeout");
    } catch (e) {
      throw Exception("Error while fetching data: $e");
    }
  }
}