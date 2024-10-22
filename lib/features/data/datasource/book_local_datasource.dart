import 'package:book/features/data/models/book_model.dart';
import 'package:hive/hive.dart';

abstract class BookLocalDatasource {
  Future<void> addBook(BookModel bookModel);
  Future<List<BookModel>> getBooks();
  Future<void> deleteBook(BookModel bookModel);
}

class BookLocalDatasourceImpl implements BookLocalDatasource {
  final String _boxName = "savedBooks";

  Future<Box<BookModel>> get _box async => Hive.openBox<BookModel>(_boxName);
  @override
  Future<void> addBook(BookModel bookModel) async {
    final box = await _box;
    await box.add(bookModel);
  }

  @override
  Future<void> deleteBook(BookModel bookModel) async {
    final box = await _box;
    final books = await getBooks();
    final index = books.indexWhere(
      (book) {
        return book.id == bookModel.id;
      },
    );
    await box.deleteAt(index);
  }

  @override
  Future<List<BookModel>> getBooks() async {
    final box = await _box;
    return box.values.toList();
  }
}
