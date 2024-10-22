import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:book/core/constants/enums.dart';
import 'package:book/core/theme/app_colors.dart';
import 'package:book/core/widgets/cache_image.dart';
import 'package:book/features/domain/entity/book_entity.dart';
import 'package:book/features/presentation/audio_listening/pages/audio_listening_screen.dart';
import 'package:book/features/presentation/home/pages/book_reader_screen.dart';
import 'package:book/features/presentation/favorite_screen/bloc/favourite_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class BookInfoScreen extends StatelessWidget {
  final BookEntity book;
  final BookType bookType;
  const BookInfoScreen({
    super.key,
    required this.bookType,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    double appBarHeight = MediaQuery.of(context).size.height / 2.1;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              BlocConsumer<FavouriteBloc, FavouriteState>(
                bloc: context.read<FavouriteBloc>()
                  ..add(GetFavouriteBooksEvent()),
                listenWhen: (previous, current) =>
                    current is FavouriteActionState,
                listener: (context, state) {
                  if (state is FavouriteActionState) {
                    final message = state.isAdded
                        ? 'Added to favorites'
                        : 'Removed from favorites';
                    final backgroundColor =
                        state.isAdded ? Colors.green : Colors.red;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: backgroundColor,
                        duration: const Duration(milliseconds: 500),
                      ),
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    current is FavouriteLoadedState,
                builder: (context, state) {
                  final isFavorite = state is FavouriteLoadedState
                      ? state.bookEntity.any((favBook) => favBook.id == book.id)
                      : false;

                  return GestureDetector(
                    onTap: () {
                      final favoriteBloc = context.read<FavouriteBloc>();
                      if (isFavorite) {
                        favoriteBloc
                            .add(DeleteFavouriteBookEvent(bookEntity: book));
                      } else {
                        favoriteBloc
                            .add(AddFavouriteBookEvent(bookEntity: book));
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor.withOpacity(0.3),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
            ],
            forceMaterialTransparency: true,
            pinned: false,
            expandedHeight: appBarHeight,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Align(
                alignment: Alignment.center,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  width: 200,
                  height: 300,
                  child: CacheImage(imageUrl: book.coverImageUrl),
                ),
              ),
              centerTitle: true,
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                    ? Colors.grey[900]
                    : AppColors.primaryColor.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${"genre".tr()}: ",
                          style: TextStyle(
                            color: AdaptiveTheme.of(context).mode ==
                                    AdaptiveThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: book.genre,
                          style: const TextStyle(
                            color: Color(0xffD1618A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "author".tr(),
                    style: TextStyle(
                      color: AdaptiveTheme.of(context).mode ==
                              AdaptiveThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: AdaptiveTheme.of(context).mode ==
                                AdaptiveThemeMode.dark
                            ? Colors.black
                            : Colors.white,
                        radius: 23,
                        child: const Icon(Icons.person),
                      ),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.author,
                            style: TextStyle(
                              color: AdaptiveTheme.of(context).mode ==
                                      AdaptiveThemeMode.dark
                                  ? Colors.grey
                                  : Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${"date".tr()}: ${book.publishedDate}",
                            style: TextStyle(
                              color: AdaptiveTheme.of(context).mode ==
                                      AdaptiveThemeMode.dark
                                  ? Colors.grey
                                  : Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    book.description,
                    style: const TextStyle(),
                  ),
                  const Gap(80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FilledButton(
          style: FilledButton.styleFrom(
            fixedSize: Size(MediaQuery.of(context).size.width, 50),
            backgroundColor: AppColors.primaryColor,
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => bookType == BookType.book
                    ? BookReaderScreen(url: book.bookUrl)
                    : AudioListeningScreen(
                        audioSource: AudioSource.uri(
                          Uri.parse(
                            book.bookUrl,
                          ),
                          tag: MediaItem(
                            id: '0',
                            title: book.title,
                            artist: book.author,
                            artUri: Uri.parse(
                              book.coverImageUrl,
                            ),
                          ),
                        ),
                      ),
              ),
            );
          },
          child: Text(
            bookType == BookType.book ? "o'qish".tr() : "listen".tr(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
