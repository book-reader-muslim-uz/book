// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookModelAdapter extends TypeAdapter<BookModel> {
  @override
  final int typeId = 0;

  @override
  BookModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookModel(
      id: fields[0] as String,
      author: fields[1] as String,
      categoryId: fields[2] as String,
      coverImageUrl: fields[3] as String,
      description: fields[4] as String,
      genre: fields[5] as String,
      bookUrl: fields[6] as String,
      publishedDate: fields[7] as String,
      title: fields[8] as String,
      isBook: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BookModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.coverImageUrl)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.genre)
      ..writeByte(6)
      ..write(obj.bookUrl)
      ..writeByte(7)
      ..write(obj.publishedDate)
      ..writeByte(8)
      ..write(obj.title)
      ..writeByte(9)
      ..write(obj.isBook);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}