import 'package:book/core/error/failure.dart';
import 'package:book/features/domain/entity/book_entity.dart';
import 'package:dartz/dartz.dart';

abstract class BookRepository {
  Future<Either<Failure, List<BookEntity>>> getBooks();
  Future<Either<Failure, List<BookEntity>>> getAudioBooks();
}
