import 'dart:async';
import 'package:dio/dio.dart';
import 'package:learning_bloc_app/models/PostModel.dart';

class PostRepository {
  final Dio _dio = Dio();
  
  Future<List<PostModel>> fetchPost() async {
    try {
      final response = await _dio.get(
        'https://jsonplaceholder.typicode.com/posts/1/comments',
        options: Options(
          responseType: ResponseType.json,
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> body = response.data;
        
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
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to load posts',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.receiveTimeout || 
          e.type == DioExceptionType.sendTimeout) {
        throw Exception("Request Timeout");
      }
      throw Exception("Error while fetching data: ${e.message}");
    } catch (e) {
      throw Exception("Error while fetching data: $e");
    }
  }
}