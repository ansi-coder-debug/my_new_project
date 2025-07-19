// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partnership.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartnershipAdapter extends TypeAdapter<Partnership> {
  @override
  final int typeId = 3;

  @override
  Partnership read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Partnership(
      id: fields[0] as String,
      partnerName: fields[1] as String,
      contactPerson: fields[2] as String,
      email: fields[3] as String,
      phone: fields[4] as String,
      sharePercentage: fields[5] as String,
      vehicleId: fields[6] as String,
      startDate: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Partnership obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.partnerName)
      ..writeByte(2)
      ..write(obj.contactPerson)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.sharePercentage)
      ..writeByte(6)
      ..write(obj.vehicleId)
      ..writeByte(7)
      ..write(obj.startDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartnershipAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
