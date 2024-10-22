part of 'favourite_bloc.dart';

sealed class FavouriteEvent extends Equatable {
  const FavouriteEvent();

  @override
  List<Object> get props => [];
}

class GetFavouriteBooksEvent extends FavouriteEvent {}

class AddFavouriteBookEvent extends FavouriteEvent {
  final BookEntity bookEntity;

  const AddFavouriteBookEvent({required this.bookEntity});
}

class DeleteFavouriteBookEvent extends FavouriteEvent {
  final  BookEntity bookEntity;
  const DeleteFavouriteBookEvent({required this.bookEntity});
}
