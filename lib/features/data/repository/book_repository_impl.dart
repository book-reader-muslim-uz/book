import 'package:book/core/error/failure.dart';
import 'package:book/features/data/datasource/book_remote_datasource.dart';
import 'package:book/features/domain/entity/book_entity.dart';
import 'package:book/features/domain/repository/book_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDatasource bookRemoteDatasource;

  BookRepositoryImpl({required this.bookRemoteDatasource});

  @override
  Future<Either<Failure, List<BookEntity>>> getAudioBooks() async {
    try {
      final result = await bookRemoteDatasource.getAudiobooks();
      print(result);
      return Right(result.map((model) => model.toEntity()).toList());
    } on DioException {
      throw Left(DioFailure());
    } catch (e) {
      throw Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> getBooks() async {
    try {
      final result = await bookRemoteDatasource.getBooks();
      return Right(result.map((model) => model.toEntity()).toList());
    } on DioException {
      throw Left(DioFailure());
    } catch (e) {
      throw Left(ServerFailure());
    }
  }
}
