import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:book/core/theme/app_colors.dart';
import 'package:book/core/widgets/book_grid.dart';
import 'package:book/core/widgets/custom_appbar.dart';
import 'package:book/core/widgets/custom_textfield.dart';
import 'package:book/features/domain/entity/book_entity.dart';
import 'package:book/features/presentation/home/bloc/book_bloc.dart';
import 'package:book/features/presentation/home/widgets/custom_bottom_sheet.dart';
import 'package:book/features/presentation/home/widgets/shimmer_book.dart';
import 'package:book/features/presentation/search_screen/pages/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "1";
  bool isDarkMode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isDarkMode = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
  }

  String selectedGenre = "All";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final List<Map<String, String>> _category = const [
    {
      "id": "1",
      "title": "PDF Books",
      "image": "book",
    },
    {
      "id": "2",
      "title": "Audio Books",
      "image": "audio_book",
    },
    {
      "id": "3",
      "title": "Video Books",
      "image": "video_book",
    },
  ];

  String get selectedImage => _category
      .firstWhere((element) => element['id'] == selectedCategory)['image']!;

  @override
  void initState() {
    super.initState();
    context.read<BookBloc>().add(GetBooksEvent());
  }

  Future<void> _onRefresh() async {
    context.read<BookBloc>().add(GetBooksEvent());
    await Future.delayed(const Duration(seconds: 1));
  }

  void _navigateToSearchScreen(BuildContext context) {
    final bookState = context.read<BookBloc>().state;
    if (bookState is BookLoadedState) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => SearchScreen(
            books: _filterBooksByCategory(bookState.books),
          ),
        ),
      );
    }
  }

  List<BookEntity> _filterBooksByCategory(List<BookEntity> books) {
    switch (selectedCategory) {
      case "1": // PDF Books
        return books;
      case "2": // Audio Books
        return books.where((book) => book.audioUrl != null).toList();
      case "3": // Video Books
        return books.where((book) => book.videoUrl != null).toList();
      default:
        return books;
    }
  }

  List<String> _getGenres(List<BookEntity> books) {
    Set<String> genres = {'All'};
    final filteredBooks = _filterBooksByCategory(books);
    for (var book in filteredBooks) {
      if (book.genre.isNotEmpty) {
        genres.add(book.genre);
      }
    }
    return genres.toList();
  }

  Widget _buildGenreFilter(List<String> genres) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: FilterChip(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: AppColors.primaryColor,
              ),
              label: Text(
                genre,
                style: TextStyle(
                  color: selectedGenre == genre
                      ? Colors.white
                      : isDarkMode
                          ? Colors.white
                          : Colors.black,
                ),
              ),
              selected: selectedGenre == genre,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    selectedGenre = genre;
                  });
                }
              },
              selectedColor: AppColors.primaryColor,
              backgroundColor: isDarkMode
                  ? AppColors.grey.withOpacity(0.8)
                  : Colors.grey[200],
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookContent(List<BookEntity> books) {
    // First filter by category (PDF/Audio/Video)
    final categoryFilteredBooks = _filterBooksByCategory(books);

    // Then filter by genre if needed
    final filteredBooks = selectedGenre == 'All'
        ? categoryFilteredBooks
        : categoryFilteredBooks
            .where((book) => book.genre == selectedGenre)
            .toList();

    return filteredBooks.isEmpty
        ? SizedBox(
            height: 500,
            child: Center(
              child: Text(
                  "No ${_category.firstWhere((cat) => cat['id'] == selectedCategory)['title']} available"),
            ),
          )
        : BookGrid(
            files: filteredBooks,
          );
  }

  Widget _buildContent() {
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state) {
        if (state is BookLoadedState) {
          final genres = _getGenres(state.books);
          return Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const Gap(12),
                  _buildGenreFilter(genres),
                  _buildBookContent(state.books),
                ],
              ),
            ),
          );
        } else if (state is BookErrorState) {
          return Expanded(
            child: Center(
              child: Text(state.errorMessage),
            ),
          );
        }
        return Expanded(
          child: buildShimmerLoading(context),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: RefreshIndicator(
        color: AppColors.primaryColor,
        key: _refreshIndicatorKey,
        onRefresh: _onRefresh,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextfield(
                      readOnly: true,
                      onTap: () => _navigateToSearchScreen(context),
                    ),
                  ),
                  const Gap(10),
                  InkWell(
                    splashColor: AppColors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => CustomBottomSheet(
                          selectedCategory: selectedCategory,
                          onTap: (categoryId) {
                            setState(() {
                              selectedCategory = categoryId;
                              selectedGenre =
                                  'All'; // Reset genre when changing category
                            });
                          },
                        ),
                      );
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/filter.png",
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }
}
