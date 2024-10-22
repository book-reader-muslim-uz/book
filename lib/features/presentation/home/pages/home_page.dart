import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:book/core/constants/enums.dart';
import 'package:book/core/theme/app_colors.dart';
import 'package:book/core/widgets/book_grid.dart';
import 'package:book/core/widgets/custom_appbar.dart';
import 'package:book/core/widgets/custom_textfield.dart';
import 'package:book/features/domain/entity/book_entity.dart';
import 'package:book/features/presentation/home/audiobloc/audio_book_bloc.dart';
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
      "title": "Books",
      "image": "book",
    },
    {
      "id": "2",
      "title": "Audio Books",
      "image": "audio_book",
    },
  ];

  String get selectedImage => _category
      .firstWhere((element) => element['id'] == selectedCategory)['image']!;

  @override
  void initState() {
    super.initState();
    context.read<BookBloc>().add(GetBooksEvent());
    context.read<AudioBookBloc>().add(GetAudioBooksEvent());
  }

  Future<void> _onRefresh() async {
    if (selectedCategory == "1") {
      context.read<BookBloc>().add(GetBooksEvent());
    } else {
      context.read<AudioBookBloc>().add(GetAudioBooksEvent());
    }
    await Future.delayed(const Duration(seconds: 1));
  }

  void _navigateToSearchScreen(BuildContext context) {
    if (selectedCategory == "1") {
      final bookState = context.read<BookBloc>().state;
      if (bookState is BookLoadedState) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SearchScreen(
              books: bookState.books,
              bookType: BookType.book,
            ),
          ),
        );
      }
    } else {
      final audioBookState = context.read<AudioBookBloc>().state;
      if (audioBookState is AudioBookLoadedState) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SearchScreen(
              books: audioBookState.books,
              bookType: BookType.audioBook,
            ),
          ),
        );
      }
    }
  }

  List<String> _getGenres(List<BookEntity> books) {
    Set<String> genres = {'All'};
    for (var book in books) {
      genres.add(book.genre);
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

  Widget _buildBookContent(List<BookEntity> books, BookType bookType) {
    final filteredBooks = selectedGenre == 'All'
        ? books
        : books.where((book) => book.genre == selectedGenre).toList();

    return filteredBooks.isEmpty
        ? const SizedBox(
            height: 500,
            child: Center(
              child: Text("No books available"),
            ),
          )
        : BookGrid(
            files: filteredBooks,
            bookType: bookType,
          );
  }

  Widget _buildContent() {
    return selectedCategory == "1"
        ? BlocBuilder<BookBloc, BookState>(
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
                        _buildBookContent(state.books, BookType.book),
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
          )
        : BlocBuilder<AudioBookBloc, AudioBookState>(
            builder: (context, state) {
              if (state is AudioBookLoadedState) {
                final genres = _getGenres(state.books);
                return Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const Gap(12),
                        _buildGenreFilter(genres),
                        _buildBookContent(state.books, BookType.audioBook),
                      ],
                    ),
                  ),
                );
              } else if (state is AudioBookErrorState) {
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
                              selectedGenre = 'All';
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
                          "assets/images/$selectedImage.png",
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
