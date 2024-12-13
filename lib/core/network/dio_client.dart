import 'package:dio/dio.dart';

class DioClient {
  final _dio = Dio();

  DioClient._singleton() {
    _dio.options
      ..connectTimeout = const Duration(seconds: 5) // Increased timeout
      ..receiveTimeout = const Duration(seconds: 8) // Increased timeout
      ..baseUrl = "https://book-admin-89e66-default-rtdb.firebaseio.com/"
      ..responseType = ResponseType.json;

    // Add logging interceptor to see what's happening
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  static final _singletonConstructor = DioClient._singleton();
  factory DioClient() {
    return _singletonConstructor;
  }

  Future<Response> get(
      {required String url, Map<String, dynamic>? queryParameters}) async {
    try {
      // Ensure URL ends with .json for Firebase REST API
      final firebaseUrl = url.endsWith('.json') ? url : '$url.json';

      final response = await _dio.get(
        firebaseUrl,
        queryParameters: {
          ...?queryParameters,
        },
      );

      // Check if response has data
      if (response.data == null) {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'No data found',
        );
      }

      return response;
    } on DioException catch (e) {
      print('DioError: ${e.message}');
      print('Response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Other error: $e');
      rethrow;
    }
  }
}
