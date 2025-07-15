// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmployeeAdapter extends TypeAdapter<Employee> {
  @override
  final int typeId = 1;

  @override
  Employee read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Employee(
      name: fields[0] as String,
      designation: fields[1] as String,
      joiningYear: fields[2] as String,
      phoneNumber: fields[3] as String,
      salary: fields[4] as String,
      status: fields[5] as String,
      id: fields[6] as String,
      imageUrl: fields[7] as String,
      address: fields[9] as String?,
      description: fields[8] as String?,
      emergencyContact: fields[10] as String?,
      bloodGroup: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Employee obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.designation)
      ..writeByte(2)
      ..write(obj.joiningYear)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.salary)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.address)
      ..writeByte(10)
      ..write(obj.emergencyContact)
      ..writeByte(11)
      ..write(obj.bloodGroup);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
