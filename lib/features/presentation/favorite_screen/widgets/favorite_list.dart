import 'package:book/features/domain/entity/book_entity.dart';
import 'package:book/features/presentation/favorite_screen/bloc/favourite_bloc.dart';
import 'package:book/features/presentation/favorite_screen/widgets/favorite_card.dart';
import 'package:book/features/presentation/favorite_screen/widgets/favorite_no_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteList extends StatelessWidget {
  final List<BookEntity> favorites;

  const FavoriteList({
    super.key,
    required this.favorites,
  });

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return const FavoriteNoItems();
    }
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final book = favorites[index];
        return Dismissible(
          key: ValueKey(book.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm"),
                      content: const Text(
                          "Are you sure you want to remove this item from favorites?"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: const Text("Delete"),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    );
                  },
                ) ??
                false;
          },
          onDismissed: (direction) {
            context
                .read<FavouriteBloc>()
                .add(DeleteFavouriteBookEvent(bookEntity: book));
          },
          background: Container(
            color: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: AlignmentDirectional.centerEnd,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  "O'chirish",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          child: FavoriteCard(book: book),
        );
      },
    );
  }
}
