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
      title: fields[0] as String,
      imageUrl: fields[1] as String,
      price: fields[2] as String,
      mileage: fields[3] as String,
      color: fields[4] as String,
      vin: fields[5] as String,
      task: fields[6] as String,
      status: fields[7] as String,
      year: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Vehicle obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.imageUrl)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.mileage)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.vin)
      ..writeByte(6)
      ..write(obj.task)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.year);
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
