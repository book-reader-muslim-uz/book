import 'package:book/features/domain/entity/book_entity.dart';
import 'package:hive/hive.dart';

part 'book_model.g.dart';

@HiveType(typeId: 0)
class BookModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String author;
  @HiveField(2)
  String categoryId;
  @HiveField(3)
  String coverImageUrl;
  @HiveField(4)
  String description;
  @HiveField(5)
  String genre;
  @HiveField(6)
  String bookUrl;
  @HiveField(7)
  String publishedDate;
  @HiveField(8)
  String title;
  @HiveField(9)
  bool isBook;

  BookModel({
    required this.id,
    required this.author,
    required this.categoryId,
    required this.coverImageUrl,
    required this.description,
    required this.genre,
    required this.bookUrl,
    required this.publishedDate,
    required this.title,
    required this.isBook,
  });

  BookEntity toEntity() {
    return BookEntity(
      id: id,
      author: author,
      categoryId: categoryId,
      coverImageUrl: coverImageUrl,
      description: description,
      genre: genre,
      bookUrl: bookUrl,
      publishedDate: publishedDate,
      isBook: isBook,
      title: title,
    );
  }

  factory BookModel.fromMap(Map<String, dynamic> map, {required bool isBook}) {
    return BookModel(
      id: map['id'] as String,
      author: map['author'] as String,
      categoryId: map['categoryId'] as String,
      coverImageUrl: map['coverImageUrl'] as String,
      description: map['description'] as String,
      genre: map['genre'] as String,
      isBook: isBook,
      bookUrl: map['bookUrl'] as String,
      publishedDate: map['publishedDate'] as String,
      title: map['title'] as String,
    );
  }
}
