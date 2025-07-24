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
      vehicleId: fields[0] as String,
      buyerName: fields[1] as String,
      buyerPhone: fields[2] as String,
      buyerAddress: fields[3] as String,
      modeOfPayment: fields[4] as String,
      date: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Sales obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.vehicleId)
      ..writeByte(1)
      ..write(obj.buyerName)
      ..writeByte(2)
      ..write(obj.buyerPhone)
      ..writeByte(3)
      ..write(obj.buyerAddress)
      ..writeByte(4)
      ..write(obj.modeOfPayment)
      ..writeByte(5)
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
