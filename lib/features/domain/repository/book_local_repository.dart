import 'package:book/core/error/failure.dart';
import 'package:book/features/data/models/book_model.dart';
import 'package:book/features/domain/entity/book_entity.dart';
import 'package:dartz/dartz.dart';

abstract class BookLocalRepository {
  Future<Either<Failure, List<BookEntity>>> getBooks();
  Future<Either<Failure, void>> addBook(BookModel bookModel);
  Future<Either<Failure, void>> deleteBook(BookModel  bookModel);
}
