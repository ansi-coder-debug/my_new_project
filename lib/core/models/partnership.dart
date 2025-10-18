import 'package:my_new_project/core/models/partner.dart';

class Partnership {
  final String? id;
  final String? partnerName;
  final String? contactPerson;
  final String? email;
  final String? phone;
  final String? sharePercentage;
  final String? vehicleId;
  final String? startDate;
  final Partner? partner;
  final String? contribution;
  final String? contributionPaid; // NEW field
  final String? paymentMode;
  final String? contributionStatus;
  final int? fromAccount;
  final String? accountName;
  final String? vehicleMake;
final String? vehicleModel;
final String? vehicleRegNo;





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
    this.paymentMode,
    this.contributionStatus,
    this.fromAccount,
    this.accountName,
    this.contributionPaid,
     this.vehicleMake,     // NEW
  this.vehicleModel,    // NEW
  this.vehicleRegNo, 


  });

factory Partnership.fromJson(Map<String, dynamic> json) {
    print('fromJson -> vehicle_make: ${json['vehicle_make']}, vehicle_model: ${json['vehicle_model']}');

    return Partnership(
      id: json['id']?.toString(),
      partnerName: json['partner_name'],
      phone: json['partner_phone'],
      sharePercentage: json['profit_share']?.toString(),
      vehicleId: json['vehicle_id']?.toString(),
    
      contribution: json['contribution']?.toString(),
      contributionPaid: json['contribution_payment_paid']?.toString(),
      contributionStatus: json['contribution_payment_status'],
      paymentMode: json['profit_share_payment_status'],
      fromAccount: json['from_account'] is int
          ? json['from_account']
          : int.tryParse(json['from_account']?.toString() ?? ''),
      accountName: json['account_name'] ?? '',
       vehicleMake: json['vehicle_make'],      // NEW
    vehicleModel: json['vehicle_model'],    // NEW
    vehicleRegNo: json['vehicle_reg_no'],   // NEW

    
    );
    
  }

  
Map<String, dynamic> toJson() {
  return {
    
    'partner_id': int.tryParse(partner?.id ?? '0') ?? 0,
    'partner_name': partnerName ?? partner?.name ?? '',
    'contribution':double.tryParse(contribution ?? '0') ?? 0.0,
    'profit_share': double.tryParse(sharePercentage ?? '0') ?? 0.0, 
    'mode_of_payment': paymentMode ?? 'cash', // Backend expects mode_of_payment
    'contribution_payment_status': contributionStatus ?? 'pending',
    'profit_share_payment_status': 'pending', // Backend requires this field
     'vehicle_id': int.tryParse(vehicleId ?? '0') ?? 0, 
     
  };
}



  /// ✅ CopyWith for Partnership
  Partnership copyWith({
    String? id,
    String? partnerName,
    String? contactPerson,
    String? email,
    String? phone,
    String? sharePercentage,
     String? vehicleId,
    String? startDate,
    Partner? partner,
    String? contribution,
    String? paymentMode,
    String? contributionStatus,
  }) {
    return Partnership(
      id: id ?? this.id,
      partnerName: partnerName ?? this.partnerName,
      contactPerson: contactPerson ?? this.contactPerson,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      sharePercentage: sharePercentage ?? this.sharePercentage,
       vehicleId: vehicleId ?? this.vehicleId,
      startDate: startDate ?? this.startDate,
      partner: partner ?? this.partner,
      contribution: contribution ?? this.contribution,
      paymentMode: paymentMode ?? this.paymentMode,
      contributionStatus: contributionStatus ?? this.contributionStatus,
    );
  }
  
}
