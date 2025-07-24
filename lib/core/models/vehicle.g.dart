// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VehicleAdapter extends TypeAdapter<Vehicle> {
  @override
  final int typeId = 0;

  @override
  Vehicle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vehicle(
      id: fields[0] as String,
      title: fields[1] as String,
      imageUrl: fields[2] as String,
      price: fields[3] as String,
      mileage: fields[4] as String,
      color: fields[5] as String,
      vin: fields[6] as String,
      task: fields[7] as String,
      status: fields[8] as String,
      year: fields[9] as String,
      description: fields[10] as String?,
      purchaseDate: fields[11] as String?,
      partnership: fields[12] as Partnership?,
      salesId: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Vehicle obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.mileage)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.vin)
      ..writeByte(7)
      ..write(obj.task)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.year)
      ..writeByte(10)
      ..write(obj.description)
      ..writeByte(11)
      ..write(obj.purchaseDate)
      ..writeByte(12)
      ..write(obj.partnership)
      ..writeByte(13)
      ..write(obj.salesId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
