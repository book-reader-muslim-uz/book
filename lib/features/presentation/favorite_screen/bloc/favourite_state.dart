part of 'favourite_bloc.dart';

sealed class FavouriteState extends Equatable {
  const FavouriteState();

  @override
  List<Object> get props => [];
}

final class FavouriteInitialState extends FavouriteState {}

final class FavouriteLoadingState extends FavouriteState {}

final class FavouriteLoadedState extends FavouriteState {
  final List<BookEntity> bookEntity;

  const FavouriteLoadedState({required this.bookEntity});
}

final class FavouriteErrorState extends FavouriteState {
  final String errorMessage;

  const FavouriteErrorState({required this.errorMessage});
}

class FavouriteActionState extends FavouriteState {
  final bool isAdded;

  const FavouriteActionState({required this.isAdded});
}
