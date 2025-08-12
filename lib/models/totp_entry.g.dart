// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'totp_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TOTPEntryAdapter extends TypeAdapter<TOTPEntry> {
  @override
  final int typeId = 4;

  @override
  TOTPEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TOTPEntry(
      issuer: fields[0] as String,
      account: fields[1] as String,
      secret: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TOTPEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.issuer)
      ..writeByte(1)
      ..write(obj.account)
      ..writeByte(2)
      ..write(obj.secret);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TOTPEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
