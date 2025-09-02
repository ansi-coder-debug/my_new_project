import 'package:hive_flutter/adapters.dart';
import 'package:my_new_project/core/models/partner.dart';
part 'partnership.g.dart';


@HiveType(typeId: 3)
class Partnership extends HiveObject {
  @HiveField(0)
  final String ? id;

  @HiveField(1)
  final String ?partnerName;

  @HiveField(2)
  final String ?contactPerson;

  @HiveField(3)
  final String ?email;

  @HiveField(4)
  final String ?phone;

  @HiveField(5)
  final String ?sharePercentage;

  @HiveField(6)
  final String ?vehicleId;

  @HiveField(7)
  final String ?startDate;

   final String ? partner;
  final String ?contribution;
  final String ?profitShare;
  final String ?paymentMode;
  final String ?contributionStatus;
  final String ?profitShareStatus;

  Partnership({
    this.id,
    this.partnerName,
     this.contactPerson,
    this.email,
     this.phone,
    this.sharePercentage,
     this.vehicleId,
    this.startDate,

     this.partner,
     this.contribution,
     this.profitShare,
     this.paymentMode,
    this.contributionStatus,
     this.profitShareStatus,




  });

 
  /// ✅ Convert JSON → Partnership object
  factory Partnership.fromJson(Map<String, dynamic> json) {
    return Partnership(
      id: json['id'].toString(),
      partnerName: json['partner_name'] ?? '',
      contactPerson: json['contact_person'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      sharePercentage: json['share_percentage']?.toString() ?? '0',
      vehicleId: json['vehicle_id'].toString(),
      startDate: json['start_date'] ?? '',
    );
  }

  
  /// ✅ Convert Partnership → JSON (for API request body)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partner_name': partnerName,
      'contact_person': contactPerson,
      'email': email,
      'phone': phone,
      'share_percentage': sharePercentage,
      'vehicle_id': vehicleId,
      'start_date': startDate,
    };
  }















  // new model we going to use 

// class Partnership {
//   final String partner;
//   final String contribution;
//   final String profitShare;
//   final String paymentMode;
//   final String contributionStatus;
//   final String profitShareStatus;

//   Partnership({
//     required this.partner,
//     required this.contribution,
//     required this.profitShare,
//     required this.paymentMode,
//     required this.contributionStatus,
//     required this.profitShareStatus,
//   });
// }


}
