part of 'search_cubit.dart';

class SearchState extends Equatable {
  final List<BookEntity> searchResults;
  final String query;
  final List<String> searchHistory;

  const SearchState({
    required this.searchResults,
    required this.query,
    required this.searchHistory,
  });

  SearchState copyWith({
    List<BookEntity>? searchResults,
    String? query,
    List<String>? searchHistory,
  }) {
    return SearchState(
      searchResults: searchResults ?? this.searchResults,
      query: query ?? this.query,
      searchHistory: searchHistory ?? this.searchHistory,
    );
  }

  @override
  List<Object?> get props => [searchResults, query, searchHistory];
}
