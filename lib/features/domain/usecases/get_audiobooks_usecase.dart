import 'package:book/core/error/failure.dart';
import 'package:book/core/usecase/usecase.dart';
import 'package:book/features/domain/entity/book_entity.dart';
import 'package:book/features/domain/repository/book_repository.dart';
import 'package:dartz/dartz.dart';

class GetAudiobooksUsecase extends Usecase<List<BookEntity>, NoParams> {
  final BookRepository bookRepository;

  GetAudiobooksUsecase({required this.bookRepository});

  @override
  Future<Either<Failure, List<BookEntity>>> call(params) async {
    return await bookRepository.getAudioBooks();
  }
}
