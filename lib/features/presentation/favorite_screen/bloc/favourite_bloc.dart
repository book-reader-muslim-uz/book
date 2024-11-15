// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:book/core/usecase/usecase.dart';
import 'package:equatable/equatable.dart';

import 'package:book/features/domain/entity/book_entity.dart';
import 'package:book/features/domain/usecases/local_book_usecases.dart';

part 'favourite_event.dart';
part 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  final GetLocalBooksUseCase getLocalBooksUseCase;
  final AddLocalBookUsecase addLocalBookUsecase;
  final DeleteLocalBookUsecase deleteLocalBookUsecase;
  FavouriteBloc(
    this.deleteLocalBookUsecase,
    this.getLocalBooksUseCase,
    this.addLocalBookUsecase,
  ) : super(FavouriteInitialState()) {
    on<GetFavouriteBooksEvent>(_getBooks);
    on<AddFavouriteBookEvent>(_addBook);
    on<DeleteFavouriteBookEvent>(_deleteBook);
  }

  _deleteBook(
      DeleteFavouriteBookEvent event, Emitter<FavouriteState> emit) async {
    emit(FavouriteLoadingState());
    final result = await deleteLocalBookUsecase.call(event.bookEntity);

    result.fold(
      (l) => emit(FavouriteErrorState(errorMessage: l.toString())),
      (r) => add(GetFavouriteBooksEvent()),
    );
  }

  _addBook(AddFavouriteBookEvent event, Emitter<FavouriteState> emit) async {
    emit(FavouriteLoadingState());

    final result = await addLocalBookUsecase.call(event.bookEntity);
    result.fold(
      (l) => emit(FavouriteErrorState(errorMessage: l.toString())),
      (r) => add(GetFavouriteBooksEvent()),
    );
  }

  _getBooks(GetFavouriteBooksEvent event, Emitter<FavouriteState> emit) async {
    emit(FavouriteLoadingState());
    final result = await getLocalBooksUseCase.call(NoParams());

    result.fold(
      (l) => emit(FavouriteErrorState(errorMessage: l.toString())),
      (r) => emit(FavouriteLoadedState(bookEntity: r)),
    );
  }
}
