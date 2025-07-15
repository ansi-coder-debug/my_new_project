import 'package:hive_flutter/hive_flutter.dart';
part 'employee.g.dart'; 


@HiveType(typeId:1)
class Employee extends HiveObject{
  @HiveField(0) final String name;
  @HiveField(1) final String designation;
  @HiveField(2) final String joiningYear;
  @HiveField(3) final String phoneNumber;
  @HiveField(4) final String salary;
  @HiveField(5) final String status;
  @HiveField(6) final String id;
  @HiveField(7) final String imageUrl;
  // ✅ New fields for details only:
  @HiveField(8)
  String? description;

  @HiveField(9)
  String? address;

  @HiveField(10)
  String? emergencyContact;

  @HiveField(11)
  String? bloodGroup;


  Employee({
    required this.name,
     required this.designation,
      required this.joiningYear,
       required this.phoneNumber,
        required this.salary,
         required this.status,
          required this.id,
          required this.imageUrl,
          this.address,
          this.description,
          this.emergencyContact,
          this.bloodGroup
  });

}




