// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:book/core/error/failure.dart';
import 'package:book/features/data/datasource/book_local_datasource.dart';
import 'package:book/features/data/models/book_model.dart';
import 'package:book/features/domain/entity/book_entity.dart';
import 'package:book/features/domain/repository/book_local_repository.dart';

class BookLocalRepositoryImpl implements BookLocalRepository {
  BookLocalDatasource bookLocalDatasource;
  BookLocalRepositoryImpl({
    required this.bookLocalDatasource,
  });
  @override
  Future<Either<Failure, void>> addBook(BookModel bookModel) async {
    try {
      await bookLocalDatasource.addBook(bookModel);
      return const Right(null);
    } catch (e) {
      throw Left(e);
    }
  }

  @override
  Future<Either<Failure, void>> deleteBook(BookModel bookModel) async {
    try {
      await bookLocalDatasource.deleteBook(bookModel);
      return const Right(null);
    } catch (e) {
      throw Left(e);
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> getBooks() async {
    try {
      final result = await bookLocalDatasource.getBooks();
      final list = result.map((e) => e.toEntity()).toList();
      return Right(list);
    } catch (e) {
      throw Left(e);
    }
  }
}
