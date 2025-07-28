// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalesAdapter extends TypeAdapter<Sales> {
  @override
  final int typeId = 5;

  @override
  Sales read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sales(
      id: fields[0] as String,
      vehicleId: fields[1] as String,
      buyerName: fields[2] as String,
      buyerPhone: fields[3] as String,
      buyerAddress: fields[4] as String,
      modeOfPayment: fields[5] as String,
      date: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Sales obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.vehicleId)
      ..writeByte(2)
      ..write(obj.buyerName)
      ..writeByte(3)
      ..write(obj.buyerPhone)
      ..writeByte(4)
      ..write(obj.buyerAddress)
      ..writeByte(5)
      ..write(obj.modeOfPayment)
      ..writeByte(6)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
