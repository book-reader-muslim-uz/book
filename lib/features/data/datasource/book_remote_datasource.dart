import 'package:book/core/constants/app_constants.dart';
import 'package:book/core/network/dio_client.dart';
import 'package:book/features/data/models/book_model.dart';
import 'package:dio/dio.dart';

abstract class BookRemoteDatasource {
  Future<List<BookModel>> getBooks();
  Future<List<BookModel>> getAudiobooks();
}

class BookRemoteDatasourceImpl implements BookRemoteDatasource {
  final DioClient dioClient;

  BookRemoteDatasourceImpl({required this.dioClient});
  @override
  Future<List<BookModel>> getAudiobooks() async {
    try {
      final response = await dioClient.get(url: AppConstants.audiobookUrl);
      final result = response.data as Map<String, dynamic>;

      return result.entries.map(
        (e) {
          e.value["id"] = e.key;
          return BookModel.fromMap(e.value);
        },
      ).toList();
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BookModel>> getBooks() async {
    try {
      final response = await dioClient.get(url: AppConstants.bookUrl);
      final result = response.data as Map<String, dynamic>;
      return result.entries.map(
        (e) {

          e.value["id"] = e.key;
          return BookModel.fromMap(e.value);
        },
      ).toList();
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
