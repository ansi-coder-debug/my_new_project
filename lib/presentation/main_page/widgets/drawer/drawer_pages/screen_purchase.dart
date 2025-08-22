import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive_flutter/adapters.dart';
import 'package:my_new_project/application/purchase/purchase_provider.dart';
import 'package:my_new_project/core/models/purchase.dart';
import 'package:my_new_project/widgets/purchase/purchase_card.dart';
import 'package:my_new_project/widgets/purchase/purchase_details_screen.dart';

class ScreenPurchase extends ConsumerStatefulWidget {
  const ScreenPurchase({super.key});

  @override
  ConsumerState<ScreenPurchase> createState() => _ScreenPurchaseState();
}

class _ScreenPurchaseState extends ConsumerState<ScreenPurchase> {
  // Access the Hive box that stores Purchase objects
  // final Box<Purchase> purchaseBox = Hive.box<Purchase>('purchases');//hive

  bool showPurchaseDetails = false;
  Purchase? selectedPurchase;


@override
void initState() {
  super.initState();
  // Load purchases when the screen initializes
  Future.microtask(() => ref.read(purchaseProvider.notifier).loadPurchases());
}

  @override
  Widget build(BuildContext context) {
     final purchaseState = ref.watch(purchaseProvider);
     print('Purchases in widget: ${purchaseState.purchases}');

    return Scaffold(
      body: purchaseState.isLoading
          ? Center(child: CircularProgressIndicator())
          : purchaseState.errorMessage != null
              ? Center(child: Text('Error: ${purchaseState.errorMessage}'))
              : purchaseState.purchases.isEmpty
                  ? Center(child: Text('No Purchases Found'))
                  : showPurchaseDetails && selectedPurchase != null
          ? PurchaseDetailsScreen(
              purchase: selectedPurchase!,
              onBack: () {
                setState(() {
                  showPurchaseDetails = false;
                  selectedPurchase = null;
                });
              },
            )
            :
            ListView.builder(
              itemCount: purchaseState.purchases.length,
              itemBuilder:(context, index){
                final purchase=purchaseState.purchases[index];
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
                        date: purchase.date.toString(),
                        price: purchase.price.toString(),
                        modeOfPayment: purchase.modeOfPayment,
                        // onDelete: onDelete,
                        // onEdit: onEdit,
                      ),
                    );
                  },
            ),
    );
  }

              }
               
      
      
      
      
      
      
      
      
      
      
      
      
    
          
          
          
               
