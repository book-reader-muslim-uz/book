import 'package:book/core/widgets/cache_image.dart';
import 'package:book/features/domain/entity/book_entity.dart';
import 'package:book/features/presentation/home/pages/book_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavoriteCard extends StatelessWidget {
  final BookEntity book;

  const FavoriteCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    // print(book.audioUrl);
    // print(book.bookUrl);
    // print(book.videoUrl);
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CacheImage(imageUrl: book.coverImageUrl),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: SizedBox(
              width: 50,
              height: 50,
              child: CacheImage(imageUrl: book.coverImageUrl),
            ),
            title: Text(
              book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onPressed: () => _navigateToBookInfoScreen(context, book),
            ),
            onTap: () => _navigateToBookInfoScreen(context, book),
          ),
        ],
      ),
    );
  }

  void _navigateToBookInfoScreen(
    BuildContext context,
    BookEntity book,
  ) {
    // print(book.audioUrl);
    // print(book.bookUrl);
    // print(book.videoUrl);
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => BookInfoScreen(
          book: book,
        ),
      ),
    );
  }
}
