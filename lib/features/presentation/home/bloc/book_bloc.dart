import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:book/core/usecase/usecase.dart';
import 'package:book/features/domain/entity/book_entity.dart';
import 'package:book/features/domain/usecases/get_books_usecase.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final GetBooksUsecase getBooksUsecase;
  BookBloc(
    this.getBooksUsecase,
  ) : super(BookInitialState()) {
    on<GetBooksEvent>(_onGetBooks);
  }

  _onGetBooks(GetBooksEvent event, Emitter<BookState> emit) async {
    emit(BookLoadingState());
    final result = await getBooksUsecase.call(NoParams());
    result.fold(
      (l) => emit(BookErrorState(errorMessage: l.toString())),
      (r) => emit(BookLoadedState(books: r)),
    );
  }
}
