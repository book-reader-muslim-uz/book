class BookEntity {
  String id;
  final String title;
  final String author;
  final String description;
  final String? bookUrl;
  final String? audioUrl;
  final String? videoUrl;
  final String coverImageUrl;
  final String publishedDate;
  final String genre;
  final String categoryId;

  BookEntity({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    this.bookUrl,
    this.audioUrl,
    this.videoUrl,
    required this.coverImageUrl,
    required this.publishedDate,
    required this.genre,
    required this.categoryId,
  });
}
