class Employee {
  final String name;
  final String designation;
  final String joiningYear;
  final String phoneNumber;
  final String salary;
  final String status;
  final String id;
  final String imageUrl;
  // ✅ New fields for details only:

  String? description;

  String? address;

  String? emergencyContact;

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
    this.bloodGroup,
  });
}
