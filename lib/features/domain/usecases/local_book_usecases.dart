import 'package:book/core/error/failure.dart';
import 'package:book/core/usecase/usecase.dart';
import 'package:book/features/data/models/book_model.dart';
import 'package:book/features/domain/entity/book_entity.dart';
import 'package:book/features/domain/repository/book_local_repository.dart';
import 'package:dartz/dartz.dart';

class AddLocalBookUsecase extends Usecase<void, BookEntity> {
  final BookLocalRepository bookLocalRepository;

  AddLocalBookUsecase({required this.bookLocalRepository});

  @override
  Future<Either<Failure, void>> call(BookEntity params) async {
    return await bookLocalRepository.addBook(
      BookModel(
        id: params.id,
        author: params.author,
        isBook: params.isBook,
        categoryId: params.categoryId,
        coverImageUrl: params.coverImageUrl,
        description: params.description,
        genre: params.genre,
        bookUrl: params.bookUrl,
        publishedDate: params.publishedDate,
        title: params.title,
      ),
    );
  }
}

class DeleteLocalBookUsecase extends Usecase<void, BookEntity> {
  final BookLocalRepository bookLocalRepository;

  DeleteLocalBookUsecase({required this.bookLocalRepository});

  @override
  Future<Either<Failure, void>> call(BookEntity params) async {
    return await bookLocalRepository.deleteBook(
      BookModel(
        id: params.id,
        author: params.author,
        isBook: params.isBook,
        categoryId: params.categoryId,
        coverImageUrl: params.coverImageUrl,
        description: params.description,
        genre: params.genre,
        bookUrl: params.bookUrl,
        publishedDate: params.publishedDate,
        title: params.title,
      ),
    );
  }
}

class GetLocalBooksUseCase extends Usecase<List<BookEntity>, NoParams> {
  final BookLocalRepository bookLocalRepository;

  GetLocalBooksUseCase({required this.bookLocalRepository});

  @override
  Future<Either<Failure, List<BookEntity>>> call(NoParams params) async {
    return await bookLocalRepository.getBooks();
  }
}
