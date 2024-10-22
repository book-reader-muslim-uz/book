import 'package:dio/dio.dart';

class DioClient {
  final _dio = Dio();

  DioClient._singleton() {
    _dio.options
      ..connectTimeout = const Duration(seconds: 2)
      ..receiveTimeout = const Duration(seconds: 4)
      ..baseUrl = "https://book-admin-89e66-default-rtdb.firebaseio.com/";
  }

  static final _singletonConstructor = DioClient._singleton();
  factory DioClient() {
    return _singletonConstructor;
  }

  Future<Response> get(
      {required String url, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
