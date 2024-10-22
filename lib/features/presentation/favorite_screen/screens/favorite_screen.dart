import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:book/core/constants/enums.dart';
import 'package:book/core/widgets/cache_image.dart';
import 'package:book/features/domain/entity/book_entity.dart';
import 'package:book/features/presentation/favorite_screen/bloc/favourite_bloc.dart';
import 'package:book/features/presentation/home/pages/book_info_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey _deleteKey = GlobalKey();
  bool isFirstTime = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkFirstTime();
    context.read<FavouriteBloc>().add(GetFavouriteBooksEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirstTime = prefs.getBool('isFirstFavorite') ?? true;
    });
    if (isFirstTime) {
      await prefs.setBool('isFirstFavorite', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'favorites'.tr(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'book'.tr()),
            Tab(text: 'audiobook'.tr()),
          ],
        ),
      ),
      body: BlocConsumer<FavouriteBloc, FavouriteState>(
        listener: (context, state) {
          if (state is FavouriteErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          if (state is FavouriteLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavouriteLoadedState) {
            final favorites = state.bookEntity;
            if (favorites.isEmpty) {
              return isFirstTime
                  ? FavoriteShowcase(deleteKey: _deleteKey)
                  : const FavoriteNoItems();
            }
            return TabBarView(
              controller: _tabController,
              children: [
                FavoriteList(
                  favorites: favorites.where((book) => book.isBook).toList(),
                  deleteKey: _deleteKey,
                ),
                FavoriteList(
                  favorites: favorites.where((book) => !book.isBook).toList(),
                  deleteKey: _deleteKey,
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class FavoriteCard extends StatelessWidget {
  final BookEntity book;

  const FavoriteCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookInfoScreen(
          book: book,
          bookType: book.isBook ? BookType.book : BookType.audioBook,
        ),
      ),
    );
  }
}

class FavoriteList extends StatelessWidget {
  final List<BookEntity> favorites;
  final GlobalKey deleteKey;

  const FavoriteList({
    super.key,
    required this.favorites,
    required this.deleteKey,
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

class FavoriteNoItems extends StatelessWidget {
  const FavoriteNoItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/not.png", width: 150),
          const SizedBox(height: 20),
          Text(
            'no_favorite'.tr(),
            style: TextStyle(
              color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                  ? Colors.white
                  : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteShowcase extends StatelessWidget {
  final GlobalKey deleteKey;

  const FavoriteShowcase({super.key, required this.deleteKey});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key("dummy"),
      onDismissed: (direction) {},
      child: const Card(
        child: ListTile(
          contentPadding: EdgeInsets.all(10),
          leading: Icon(Icons.book),
          title: Text("Dummy Book"),
          subtitle: Text("Dummy Author"),
        ),
      ),
    );
  }
}
