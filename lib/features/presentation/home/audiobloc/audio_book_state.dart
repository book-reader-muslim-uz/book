part of 'audio_book_bloc.dart';

sealed class AudioBookState extends Equatable {
  const AudioBookState();

  @override
  List<Object> get props => [];
}

final class AudioBookInitialState extends AudioBookState {}

final class AudioBookLoadedState extends AudioBookState {
  final List<BookEntity> books;

  const AudioBookLoadedState({
    required this.books,
  });
}

final class AudioBookLoadingState extends AudioBookState {}

final class AudioBookErrorState extends AudioBookState {
  final String errorMessage;

  const AudioBookErrorState({required this.errorMessage});
}
