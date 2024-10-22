import 'package:bloc/bloc.dart';
import 'package:book/features/domain/entity/book_entity.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final List<BookEntity> allBooks;

  SearchCubit({required this.allBooks})
      : super(
            const SearchState(searchResults: [], query: '', searchHistory: []));

  void onSearchChanged(String query) {
    final lowercaseQuery = query.toLowerCase();
    final results = allBooks
        .where((book) =>
            book.title.toLowerCase().contains(lowercaseQuery) ||
            book.author.toLowerCase().contains(lowercaseQuery))
        .toList();

    emit(state.copyWith(searchResults: results, query: query));
  }

  void addToSearchHistory(String query) {
    if (query.isNotEmpty && !state.searchHistory.contains(query)) {
      final updatedHistory = List<String>.from(state.searchHistory)..add(query);
      emit(state.copyWith(searchHistory: updatedHistory));
    }
  }

  void removeSearchHistoryItem(String query) {
    final updatedHistory = List<String>.from(state.searchHistory)
      ..remove(query);
    emit(state.copyWith(searchHistory: updatedHistory));
  }

  void clearSearch() {
    emit(state.copyWith(searchResults: [], query: ''));
  }
}
