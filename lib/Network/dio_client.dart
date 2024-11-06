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

  Future<List<PostModel>> fetchPost({int? id}) async {
    try {
      final response = await _dio.get(Endpoints.users);

      return (response.data as List).map((responseData) {
        return PostModel(
          postId: responseData['id'],
          name: responseData['title'],
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

  Future postData({required PostModel list}) async {
    try {
      final _ = await _dio.post(
        Endpoints.users,
        data: {
          'title': list.name,
          'body': list.body,
          "email" : "user1@gmail.com"
        },
      );
    } on DioException catch (err) {
      final errorMessage = (err.message).toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }


 Future editData({required PostModel list}) async {
  try {
    final _ = await _dio.put(
      "${Endpoints.users}/${list.postId}",  
      data: {
        'title': list.name,
        'body': list.body,
        "email": "user1@gmail.com",
      },
    );
    // Handle the response if needed
  } on DioException catch (err) {
    final errorMessage = (err.message).toString();
    throw errorMessage;
  } catch (e) {
    throw e.toString();
  }
}



   Future deleteData({required String id}) async {
    try {
      final response = await _dio.delete(
        "${Endpoints.users}/$id",
      );
    } on DioException catch (err) {
      final errorMessage = (err.message).toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }
}
