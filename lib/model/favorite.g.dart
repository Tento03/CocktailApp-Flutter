// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteAdapter extends TypeAdapter<Favorite> {
  @override
  final int typeId = 0;

  @override
  Favorite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favorite(
      strDrink: fields[0] as String,
      strDrinkThumb: fields[1] as String,
      idDrink: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Favorite obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.strDrink)
      ..writeByte(1)
      ..write(obj.strDrinkThumb)
      ..writeByte(2)
      ..write(obj.idDrink);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
