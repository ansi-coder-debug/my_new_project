import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

// import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/sales.dart';
// import 'package:my_new_project/widgets/common_search_bar.dart';
import 'package:my_new_project/widgets/sales/sales_card.dart';
import 'package:my_new_project/widgets/sales/sales_details_screen.dart';

class ScreenSales extends StatefulWidget {
  const ScreenSales({super.key});

  @override
  State<ScreenSales> createState() => _ScreenSalesState();
}

class _ScreenSalesState extends State<ScreenSales> {
  final Box<Sales> salesBox = Hive.box<Sales>('sales');
  bool showSalesDetails = false;

  Sales? selectedSales;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showSalesDetails && selectedSales != null
          ? SalesDetailsScreen(
              sales: selectedSales!,
              onBack: () {
                setState(() {
                  showSalesDetails = false;
                  selectedSales = null;
                });
              },
            )
          : ValueListenableBuilder(
              valueListenable: salesBox.listenable(),
              builder: (context, Box<Sales> box, _) {
                final saless = box.values.toList();
                if (box.values.isEmpty) {
                  return Center(child: Text('No Sales Found'));
                }
                return ListView.builder(
                  itemCount: saless.length,
                  itemBuilder: (context, index) {
                    final sales = saless[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSales = sales;
                          showSalesDetails = true;
                        });
                      },
                      child: SalesCard(
                         date: sales.date,

                         name: sales.buyerName,
                          phone:sales.buyerPhone ,
                           address:sales.buyerAddress ,
                            modeOfPayment: sales.modeOfPayment, 
                            vehicleId:sales.vehicleId ,
                            ),
                    );
                  },
                );
              },
            ),
    );
  }
}
