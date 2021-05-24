// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OptionsAdapter extends TypeAdapter<Options> {
  @override
  final int typeId = 0;

  @override
  Options read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Options()..options = (fields[0] as List)?.cast<dynamic>();
  }

  @override
  void write(BinaryWriter writer, Options obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.options);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OptionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubjectsAdapter extends TypeAdapter<Subjects> {
  @override
  final int typeId = 1;

  @override
  Subjects read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subjects()..myData = (fields[0] as List)?.cast<dynamic>();
  }

  @override
  void write(BinaryWriter writer, Subjects obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.myData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
