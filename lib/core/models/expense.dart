import 'package:hive_flutter/adapters.dart';
part 'expense.g.dart';



@HiveType(typeId: 2)
class Expense extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String title;
  @HiveField(2) final String category;
  @HiveField(3) final String amount;
  @HiveField(4) final String date;
  @HiveField(5) final String paymentMode;
  @HiveField(6) final String status;
  @HiveField(7) String? description;


  Expense({
            required this.id,
            required this.title,
            required this.category,
            required this.amount,
            required this.date,
            required this.paymentMode,
            required this.status,
            this.description
            
  });

}


// id → unique identifier

// title → what the expense is about

// category → to group similar expenses

// amount → how much was spent

// date → when it was spent

// paymentMode → how it was paid

// status → to track approval or processing

// notes → any extra info