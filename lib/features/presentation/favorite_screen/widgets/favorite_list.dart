import 'package:book/features/presentation/favorite_screen/widgets/favorite_card.dart';
import 'package:flutter/material.dart';

class FavoriteList extends StatelessWidget {
  final List<dynamic> favorites;
  final GlobalKey deleteKey;
  final void Function(int) onDismiss;

  const FavoriteList({
    super.key,
    required this.favorites,
    required this.deleteKey,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final book = favorites[index];
        return Dismissible(
          key: Key(book.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => onDismiss(index),
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
