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
      make: fields[1] as String,
      model: fields[2] as String,
      photos: (fields[3] as List).cast<String>(),
      price: fields[4] as String,
      registrationId: fields[5] as String,
      color: fields[6] as String,
      status: fields[7] as String,
      year: fields[8] as String,
      description: fields[9] as String?,
      purchaseDate: fields[10] as String?,
      purchaseName: fields[11] as String,
      purchasePhone: fields[12] as String,
      purchaseAddress: fields[13] as String,
      purchasePrice: fields[14] as String,
      purchaseMode: fields[15] as String,
      purchasePaymentStatus: fields[16] as String?,
      partnership: fields[17] as Partnership?,
      salesId: fields[18] as String?,
      mileage: fields[19] as double,
      fuelType: fields[20] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Vehicle obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.make)
      ..writeByte(2)
      ..write(obj.model)
      ..writeByte(3)
      ..write(obj.photos)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.registrationId)
      ..writeByte(6)
      ..write(obj.color)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.year)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.purchaseDate)
      ..writeByte(11)
      ..write(obj.purchaseName)
      ..writeByte(12)
      ..write(obj.purchasePhone)
      ..writeByte(13)
      ..write(obj.purchaseAddress)
      ..writeByte(14)
      ..write(obj.purchasePrice)
      ..writeByte(15)
      ..write(obj.purchaseMode)
      ..writeByte(16)
      ..write(obj.purchasePaymentStatus)
      ..writeByte(17)
      ..write(obj.partnership)
      ..writeByte(18)
      ..write(obj.salesId)
      ..writeByte(19)
      ..write(obj.mileage)
      ..writeByte(20)
      ..write(obj.fuelType);
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
