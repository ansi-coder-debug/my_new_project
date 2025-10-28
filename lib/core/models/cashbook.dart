import 'dart:convert';

import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/core/models/vehicle_summary.dart';

class CashBookEntry {
  final String? id;
  final String? userId;
  // final String accountId;
  final String? accountName; // Joined from account table
  final String transactionType; // "sale", "purchase", etc.
  final String? transactionId;
  final double? debit;
  final double? credit;
  final String? description;
  final DateTime? createdAt;
  final VehicleSummary? vehicle;
  // final String? toAccountId;
  final int accountId;
  final int? toAccountId;
  final int? fromAccountId;

  CashBookEntry({
    this.id,
    this.userId,
    required this.accountId,
    this.accountName,
    required this.transactionType,
    this.transactionId,
    this.debit,
    this.credit,
    this.description,
    this.createdAt,
    this.vehicle,
    this.toAccountId,
    this.fromAccountId
  });

  // factory CashBookEntry.fromJson(Map<String, dynamic> json) {
  //   return CashBookEntry(
  //     id: json['id']?.toString(),
  //     userId: json['user_id']?.toString(),
  //     // accountId: json['account_id']?.toString() ?? '',
  //      accountId: json['account_id']?.toString() ?? (throw Exception("account_id missing")),

  //     accountName: json['account_name'], // from JOIN
  //     // transactionType: json['transaction_type'] ?? '',
  //     transactionType: json['transaction_type']?.toString() ?? (throw Exception("transaction_type missing")),

  //     transactionId: json['transaction_id'],
  //     debit: (json['debit'] != null) ? double.tryParse(json['debit'].toString()) : null,
  //     credit: (json['credit'] != null) ? double.tryParse(json['credit'].toString()) : null,
  //     description: json['description'],
  //     createdAt: json['created_at'] != null
  //         ? DateTime.tryParse(json['created_at'])
  //         : null,
  //   );
  // }

  factory CashBookEntry.fromJson(Map<String, dynamic> json) {
  try {
    print("Raw cashbook entry JSON: ${jsonEncode(json)}");

    final accountId = json['account_id'] != null
        ? int.tryParse(json['account_id'].toString())
        : null;

    final transactionType = json['transaction_type']?.toString();

    if (accountId == null || transactionType == null) {
      print(
        "⚠️ Skipping entry: account_id or transaction_type is null. Raw JSON: $json",
      );
      throw FormatException("Missing required fields");
    }

    return CashBookEntry(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString(),
      accountId: accountId,
      accountName: json['account_name'],
      transactionType: transactionType,
      transactionId: json['transaction_id']?.toString(),
      debit: (json['debit'] != null)
          ? double.tryParse(json['debit'].toString())
          : null,
      credit: (json['credit'] != null)
          ? double.tryParse(json['credit'].toString())
          : null,
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      vehicle: (json['vehicle_name'] != null || json['vehicle_reg_no'] != null)
          ? VehicleSummary.fromJson(json)
          : null,
      toAccountId: json['to_account_id'] != null
          ? int.tryParse(json['to_account_id'].toString())
          : null,
          fromAccountId: json['from_account_id'],
    );
  } catch (e) {
    print("❌ Error parsing CashBookEntry: $e");
    rethrow;
  }
}


  // factory CashBookEntry.fromJson(Map<String, dynamic> json) {
  //   try {
  //     print("Raw cashbook entry JSON: ${jsonEncode(json)}");
  //     final accountId = json['account_id']?.toString();
  //     final transactionType = json['transaction_type']?.toString();

  //     if (accountId == null || transactionType == null) {
  //       print(
  //         "⚠️ Skipping entry: account_id or transaction_type is null. Raw JSON: $json",
  //       );
  //       throw FormatException("Missing required fields");
  //     }

  //     return CashBookEntry(
  //       id: json['id']?.toString(),
  //       userId: json['user_id']?.toString(),
  //       accountId: accountId,

  //       accountName: json['account_name'],
  //       transactionType: transactionType,
  //       transactionId: json['transaction_id']?.toString(),
  //       debit: (json['debit'] != null)
  //           ? double.tryParse(json['debit'].toString())
  //           : null,
  //       credit: (json['credit'] != null)
  //           ? double.tryParse(json['credit'].toString())
  //           : null,
  //       description: json['description'],
  //       createdAt: json['created_at'] != null
  //           ? DateTime.tryParse(json['created_at'])
  //           : null,
  //       // ✅ new vehicle summary
  //       vehicle:
  //           (json['vehicle_name'] != null || json['vehicle_reg_no'] != null)
  //           ? VehicleSummary.fromJson(json)
  //           : null,
  //       toAccountId: json['to_account_id']?.toString(),
  //     );
  //   } catch (e) {
  //     print("❌ Error parsing CashBookEntry: $e");
  //     rethrow; // Or return a fallback value
  //   }
  // }

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'to_account_id': toAccountId, // ✅ Added for transfer
       "from_account_id": fromAccountId,
      'transaction_type': transactionType,
      'transaction_id': transactionId,
      'debit': debit,
      'credit': credit,
      'description': description,
    };
  }

  CashBookEntry copyWith({
    String? id,
    String? userId,
    // String? accountId,
    int? accountId,
int? toAccountId,

    String? accountName,
    String? transactionType,
    String? transactionId,
    double? debit,
    double? credit,
    String? description,
    DateTime? createdAt,
  }) {
    return CashBookEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
      transactionType: transactionType ?? this.transactionType,
      transactionId: transactionId ?? this.transactionId,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
