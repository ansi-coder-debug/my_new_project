import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_new_project/core/models/purchase.dart';
import 'package:my_new_project/widgets/purchase/purchase_card.dart';
import 'package:my_new_project/widgets/purchase/purchase_details_screen.dart';

class ScreenPurchase extends StatefulWidget {
  const ScreenPurchase({super.key});

  @override
  State<ScreenPurchase> createState() => _ScreenPurchaseState();
}

class _ScreenPurchaseState extends State<ScreenPurchase> {
  // Access the Hive box that stores Purchase objects
  final Box<Purchase> purchaseBox = Hive.box<Purchase>('purchases');

  bool showPurchaseDetails = false;

  Purchase? selectedPurchase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showPurchaseDetails && selectedPurchase != null
          ? PurchaseDetailsScreen(
              purchase: selectedPurchase!,
              onBack: () {
                setState(() {
                  showPurchaseDetails = false;
                  selectedPurchase = null;
                });
              },
            )
          : ValueListenableBuilder(
              valueListenable: purchaseBox.listenable(),
              builder: (context, Box<Purchase> box, _) {
                final purchases = box.values.toList();
                if (box.values.isEmpty) {
                  return Center(child: Text('No Purchase Found'));
                }
                // convert box values tolist
                
                return ListView.builder(
                  itemCount: purchases.length,
                  itemBuilder: (context, index) {
                    final purchase = purchases[index];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPurchase = purchase;
                          showPurchaseDetails = true;
                        });
                      },
                      child: PurchaseCard(
                        id: purchase.id,
                        vehicleId:purchase.vehicleId ,
                        name: purchase.name,
                        phone: purchase.phone,
                        address: purchase.address,
                        date: purchase.date,
                        price: purchase.price,
                        modeOfPayment: purchase.modeOfPayment,
                        // onDelete: onDelete,
                        // onEdit: onEdit,
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
