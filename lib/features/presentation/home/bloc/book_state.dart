part of 'book_bloc.dart';

sealed class BookState extends Equatable {
  const BookState();

  @override
  List<Object> get props => [];
}

final class BookInitialState extends BookState {}

final class BookLoadedState extends BookState {
  final List<BookEntity> books;

  const BookLoadedState({
    required this.books,
  });
}

final class BookLoadingState extends BookState {}

final class BookErrorState extends BookState {
  final String errorMessage;

  const BookErrorState({required this.errorMessage});
}
