class Employee {
 final int? id;
  final String name;
  final String email;
  final String phone;
  final String position;
  final double salary;
  final String hireDate; // You can use DateTime if needed, but for simplicity, it's a String
  final String address;

  Employee({
     this.id, // nullable
    required this.name,
    required this.email,
    required this.phone,
    required this.position,
    required this.salary,
    required this.hireDate,
    required this.address,
  });

  // Factory constructor to create an Employee from JSON
  // factory Employee.fromJson(Map<String, dynamic> json) {
  //   return Employee(
  //     id: json['id'],
  //     name: json['name'],
  //     email: json['email'],
  //     phone: json['phone'],
  //     position: json['position'],
  //     salary: json['salary'].toDouble(), // Ensure salary is a double
  //     hireDate: json['hire_date'], // Or you could convert it to DateTime here
  //     address: json['address'],
  //   );
  // }
   factory Employee.fromJson(Map<String, dynamic> json) {
    print('🔹 Parsing Employee JSON: $json');
    return Employee(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      position: json['position'] ?? '',
      salary: (json['salary'] as num?)?.toDouble() ?? 0.0,
      hireDate: json['hire_date'] ?? '',
      address: json['address'] ?? '',
    );
  }


  // Method to convert Employee to JSON for POST/PUT requests
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'position': position,
      'salary': salary,
      'hire_date': hireDate,
      'address': address,
    };
  }

}
