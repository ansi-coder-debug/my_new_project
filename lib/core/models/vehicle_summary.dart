// lib/core/models/vehicle_summary.dart

class VehicleSummary {
  final String? name;
  final String? regNo;

  VehicleSummary({
    this.name,
    this.regNo,
  });

  factory VehicleSummary.fromJson(Map<String, dynamic> json) {
    return VehicleSummary(
      name: json['vehicle_name']?.toString(),
      regNo: json['vehicle_reg_no']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle_name': name,
      'vehicle_reg_no': regNo,
    };
  }

  @override
  String toString() => '$name ($regNo)';
}
