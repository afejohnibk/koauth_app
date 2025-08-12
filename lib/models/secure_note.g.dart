// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secure_note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SecureNoteAdapter extends TypeAdapter<SecureNote> {
  @override
  final int typeId = 3;

  @override
  SecureNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SecureNote(
      title: fields[0] as String,
      content: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SecureNote obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecureNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
