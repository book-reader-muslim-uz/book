class BookEntity {
  String id;
  String author;
  String categoryId;
  String coverImageUrl;
  String description;
  String genre;
  String bookUrl;
  String publishedDate;
  String title;
  bool isBook;

  BookEntity({
    required this.isBook,
    required this.id,
    required this.author,
    required this.categoryId,
    required this.coverImageUrl,
    required this.description,
    required this.genre,
    required this.bookUrl,
    required this.publishedDate,
    required this.title,
  });
}
