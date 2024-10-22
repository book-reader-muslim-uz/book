import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:book/core/constants/enums.dart';
import 'package:book/core/theme/app_colors.dart';
import 'package:book/core/widgets/cache_image.dart';
import 'package:book/features/domain/entity/book_entity.dart';
import 'package:book/features/presentation/home/pages/book_info_screen.dart';
import 'package:book/features/presentation/search_screen/cubit/search_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  final List<BookEntity> books;
  final BookType bookType;

  const SearchScreen({
    super.key,
    required this.books,
    required this.bookType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(allBooks: books),
      child: _SearchScreenContent(bookType: bookType),
    );
  }
}

class _SearchScreenContent extends StatefulWidget {
  final BookType bookType;

  const _SearchScreenContent({required this.bookType});

  @override
  _SearchScreenContentState createState() => _SearchScreenContentState();
}

class _SearchScreenContentState extends State<_SearchScreenContent> {
  late TextEditingController _searchController;
  bool isDarkMode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isDarkMode = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('search'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) =>
                  context.read<SearchCubit>().onSearchChanged(query),
              decoration: InputDecoration(
                hintText: 'search'.tr(),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state.query.isEmpty && state.searchHistory.isNotEmpty) {
            return _buildSearchHistory(context);
          } else if (state.query.isEmpty) {
            return _buildEmptySearchImage();
          } else if (state.searchResults.isEmpty) {
            return const Center(child: Text('No results found.'));
          } else {
            return _buildSearchResults(context, state);
          }
        },
      ),
    );
  }

  Widget _buildSearchHistory(BuildContext context) {
    return ListView.builder(
      itemCount: context.read<SearchCubit>().state.searchHistory.length,
      itemBuilder: (context, index) {
        final query = context.read<SearchCubit>().state.searchHistory[index];
        return ListTile(
          leading: const Icon(Icons.history),
          title: Text(query),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () =>
                context.read<SearchCubit>().removeSearchHistoryItem(query),
          ),
          onTap: () {
            _searchController.text = query;
            context.read<SearchCubit>().onSearchChanged(query);
          },
        );
      },
    );
  }

  Widget _buildEmptySearchImage() {
    return Center(
      child: Image.asset("assets/images/search_not.png"),
    );
  }

  Widget _buildSearchResults(BuildContext context, SearchState state) {
    return ListView.builder(
      itemCount: state.searchResults.length,
      itemBuilder: (context, index) {
        final book = state.searchResults[index];
        return ListTile(
          leading: SizedBox(
            width: 50.0,
            height: 50.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CacheImage(imageUrl: book.coverImageUrl),
            ),
          ),
          title: _highlightText(book.title, state.query),
          subtitle: _highlightText(book.author, state.query),
          onTap: () {
            context.read<SearchCubit>().addToSearchHistory(state.query);
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => BookInfoScreen(
                  book: book,
                  bookType: widget.bookType,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _highlightText(String text, String query) {
    if (query.isEmpty) {
      return Text(text);
    }

    List<TextSpan> spans = [];
    int start = 0;
    int indexOfMatch;

    do {
      indexOfMatch = text.toLowerCase().indexOf(query.toLowerCase(), start);

      if (indexOfMatch < 0) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }

      if (indexOfMatch > start) {
        spans.add(TextSpan(text: text.substring(start, indexOfMatch)));
      }

      spans.add(TextSpan(
        text: text.substring(indexOfMatch, indexOfMatch + query.length),
        style: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ));

      start = indexOfMatch + query.length;
    } while (true);

    return RichText(
      text: TextSpan(
        children: spans,
        style: TextStyle(
          fontSize: 14, // Set a spec
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
