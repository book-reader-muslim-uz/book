import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:book/core/theme/app_colors.dart';
import 'package:book/core/widgets/cache_image.dart';
import 'package:book/features/domain/entity/book_entity.dart';
import 'package:book/features/presentation/audio_listening/pages/audio_listening_screen.dart';
import 'package:book/features/presentation/home/pages/book_reader_screen.dart';
import 'package:book/features/presentation/favorite_screen/bloc/favourite_bloc.dart';
import 'package:book/features/presentation/home/pages/video_player_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class BookInfoScreen extends StatelessWidget {
  final BookEntity book;
  const BookInfoScreen({
    super.key,
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
              child: Stack(
                children: [
                  if (book.videoUrl != null && book.videoUrl!.isNotEmpty)
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerPage(
                                videoUrl: book.videoUrl!,
                              ),
                            ),
                          );
                        },
                        child: Container(
                            margin: const EdgeInsets.only(top: 23),
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12)),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${"genre".tr(context: context)}: ",
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
                        "author".tr(context: context),
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
                          Expanded(
                            child: Column(
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
                                  "${"date".tr(context: context)}: ${book.publishedDate}",
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
                      ),
                      const Gap(80),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          right: book.bookUrl != null ? 15 : 7.5,
          left: book.audioUrl != null ? 15 : 7.5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (book.audioUrl != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 7.5),
                  child: FloatingActionButton(
                    backgroundColor: AppColors.primaryColor,
                    heroTag: "Button1",
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        isDismissible: true,
                        useSafeArea: true,
                        builder: (context) => AudioListeningScreen(
                          audioSource: AudioSource.uri(
                            tag: MediaItem(
                              id: '0',
                              title: book.title,
                              artist: book.author,
                              artUri: Uri.parse(book.coverImageUrl),
                            ),
                            Uri.parse(book.audioUrl!),
                          ),
                        ),
                      );
                    },
                    child: Text("listen".tr(context: context)),
                  ),
                ),
              ),
            if (book.bookUrl != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 7.5),
                  child: FloatingActionButton(
                    backgroundColor: AppColors.primaryColor,
                    heroTag: "Button2",
                    onPressed: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) =>
                            BookReaderScreen(url: book.bookUrl!),
                      ));
                    },
                    child: Text("o'qish".tr(context: context)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
