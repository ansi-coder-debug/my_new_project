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

  
   factory Employee.fromJson(Map<String, dynamic> json) {
    print('🔹 Parsing Employee JSON: $json');
    return Employee(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      position: json['position'] ?? '',
      salary: double.tryParse(json['salary'].toString()) ?? 0.0,
      hireDate: json['hire_date'] != null
          ? _formatDate(json['hire_date'])
          : 'No date',
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



   // 🔧 Private helper method to format date string to "dd-MM-yyyy"
  static String _formatDate(String rawDate) {
    try {
      final parsedDate = DateTime.parse(rawDate); // ⏳ convert ISO string to DateTime
      final day = parsedDate.day.toString().padLeft(2, '0');    // pad single digit day
      final month = parsedDate.month.toString().padLeft(2, '0'); // pad single digit month
      final year = parsedDate.year;

      return '$day-$month-$year'; // 📅 Final format: 18-05-2025
    } catch (e) {
      return rawDate; // ❌ fallback if parsing fails
    }
  }
}
