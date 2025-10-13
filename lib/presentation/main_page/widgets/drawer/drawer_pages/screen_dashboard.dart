import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/expense/expense_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_inventory.dart';
import 'package:my_new_project/widgets/dashboard/dashboard_card.dart';

class ScreenDashboard extends ConsumerStatefulWidget {
  const ScreenDashboard({super.key});

  @override
  ConsumerState<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends ConsumerState<ScreenDashboard> {
  @override
  Widget build(BuildContext context) {
    final vehicleState = ref.watch(vehicleProvider);
    final totalVehicles = vehicleState.vehicles.length;
    // expenses
    final expenseState = ref.watch(expenseProvider.notifier);

    final availableVehicles = vehicleState.vehicles
        .where((v) => v.status.toLowerCase() == 'available')
        .length;

    final soldVehicles = vehicleState.vehicles
        .where((v) => v.status.toLowerCase() == 'sold')
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DashboardCard(
                  title: "Available Vehicles",

                  currentCount: availableVehicles,
                  totalCount: totalVehicles,
                  backgroundColor: Colors.white,

                  onTap: () {},
                ),
                DashboardCard(
                  title: "Sold Vehicles",
                  currentCount: soldVehicles,
                  totalCount: totalVehicles,
                  backgroundColor: Colors.white,
                  onTap: () {},
                ),
              ],
            ),
            DashboardCard(
              title: "Total Expense",
              backgroundColor: Colors.white,
              onTap: () {},
            ),
            
           
          ],
        ),
      ),
    );
  }
}
