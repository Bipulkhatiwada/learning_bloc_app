import 'package:dio/dio.dart';
import 'package:learning_bloc_app/Network/endpoints.dart';
import 'package:learning_bloc_app/Network/interceptors/authorization_interceptor.dart';
import 'package:learning_bloc_app/Network/interceptors/logger_interceptor.dart';
import 'package:learning_bloc_app/models/PostModel.dart';

class DioClient {
  late final Dio _dio;

  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: Endpoints.baseUrl,
            connectTimeout: Endpoints.connectionTimeout,
            receiveTimeout: Endpoints.receiveTimeout,
          ),
        )..interceptors.addAll([
            AuthorizationInterceptor(),
            LoggerInterceptor(),
          ]);

  Future<List<PostModel>> fetchPost({required int id}) async {
    try {
      final response = await _dio.get('${Endpoints.posts}/$id/comments');

      return (response.data as List).map((responseData) {
        return PostModel(
          postId: responseData['postId'],
          id: responseData['id'],
          name: responseData['name'],
          email: responseData['email'],
          body: responseData['body'],
        );
      }).toList();
    } on DioException catch (err) {
      final errorMessage = (err.message).toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }
}
