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
  final String? paymentMode;
  final String? contributionStatus;
  final int? fromAccount;


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
    this.fromAccount
  });

  factory Partnership.fromJson(Map<String, dynamic> json) {
    return Partnership(
      id: json['id']?.toString(),
      partnerName: json['partner_name'] ?? '',
      contactPerson: json['contact_person'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      sharePercentage: json['share_percentage']?.toString() ?? '0',
      // vehicleId: json['vehicle_id']?.toString(),
      startDate: json['start_date'] ?? '',
      partner: json['partner'] != null && json['partner'] is Map<String, dynamic>
          ? Partner.fromJson(json['partner'])
          : null,
      contribution: json['contribution']?.toString(),
      paymentMode: json['payment_mode'],
      contributionStatus: json['contribution_status'],
      fromAccount: json['from_account'] is int
    ? json['from_account']
    : int.tryParse(json['from_account']?.toString() ?? ''),

    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'partner_id': partner?.id,
  //     'partner_name': partner?.name,
  //     'address': partner?.address,
  //     'contact_person': contactPerson,
  //     'email': email,
  //     'phone': partner?.phone,
  //     'share_percentage': sharePercentage,
  //     'vehicle_id': vehicleId,
  //     'start_date': startDate,
  //     'contribution': contribution,
  //     'payment_mode': paymentMode,
  //     'contribution_status': contributionStatus,
  //   };
  // }
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
