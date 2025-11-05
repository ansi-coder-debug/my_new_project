import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';
import 'package:my_new_project/widgets/sales/sales_edit_screen.dart';
// Adjust path if needed

class ScreenSales extends ConsumerWidget {
  const ScreenSales({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleState = ref.watch(vehicleProvider);

    // Filter only sold vehicles (those with saleInfo)
    final soldVehicles = vehicleState.vehicles
        .where((vehicle) => vehicle.saleInfo != null)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            CustomHeader(
              title: 'Sales',
              // onBack: () {
              //   //last index wanna do at later
              // },
              onFilter: () {
                // TODO: Open filter
              },
              onRefresh: () {
                ref.read(vehicleProvider.notifier).loadVehicles();
              },
              onSearch: () {
                // TODO: Open search
              },
              showAdd: false, // No add button in Sales
            ),

            KHeight,

            // Content
            Expanded(
              child: soldVehicles.isEmpty
                  ? const Center(child: Text("No sale information available."))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: soldVehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = soldVehicles[index];
                        final saleInfo = vehicle.saleInfo!;

                        return OutputCard(
                          title: saleInfo.name,
                          subtitle: "${vehicle.make} ${vehicle.model}",
                          phone: saleInfo.phone,
                          amount: double.tryParse(saleInfo.price) ?? 0,
                          received:
                              double.tryParse(saleInfo.receivedPrice ?? '0') ??
                              0,
                          balance:
                              (double.tryParse(saleInfo.price) ?? 0) -
                              (double.tryParse(saleInfo.receivedPrice ?? '0') ??
                                  0),

                          onView: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SalesEditScreen(
                                  vehicle: vehicle,
                                  isEditMode: false,
                                ),
                              ),
                            );
                          },
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SalesEditScreen(
                                  vehicle: vehicle,
                                  isEditMode: true,
                                ),
                              ),
                            );
                          },
                          onDelete: ()async {
                            final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirm Delete'),
      content: Text('Are you sure you want to delete sale of ${saleInfo.name}?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
      ],
    ),
  );

  if (confirm == true) {
    // Call your delete logic here
    // e.g. ref.read(vehicleProvider.notifier).deleteSale(vehicle.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sale deleted successfully')),
    );
  }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';
import 'package:my_new_project/widgets/sales/sales_edit_screen.dart';
// Adjust path if needed

class ScreenSales extends ConsumerWidget {
  const ScreenSales({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleState = ref.watch(vehicleProvider);

    // Filter only sold vehicles (those with saleInfo)
    final soldVehicles = vehicleState.vehicles
        .where((vehicle) => vehicle.saleInfo != null)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            CustomHeader(
              title: 'Sales',
              // onBack: () {
              //   //last index wanna do at later
              // },
              onFilter: () {
                // TODO: Open filter
              },
              onRefresh: () {
                ref.read(vehicleProvider.notifier).loadVehicles();
              },
              onSearch: () {
                // TODO: Open search
              },
              showAdd: false, // No add button in Sales
            ),

            KHeight,

            // Content
            Expanded(
              child: soldVehicles.isEmpty
                  ? const Center(child: Text("No sale information available."))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: soldVehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = soldVehicles[index];
                        final saleInfo = vehicle.saleInfo!;

                        return OutputCard(
                          title: saleInfo.name,
                          subtitle: "${vehicle.make} ${vehicle.model}",
                          phone: saleInfo.phone,
                          amount: double.tryParse(saleInfo.price) ?? 0,
                          received:
                              double.tryParse(saleInfo.receivedPrice ?? '0') ??
                              0,
                          balance:
                              (double.tryParse(saleInfo.price) ?? 0) -
                              (double.tryParse(saleInfo.receivedPrice ?? '0') ??
                                  0),

                          onView: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SalesEditScreen(
                                  vehicle: vehicle,
                                  isEditMode: false,
                                ),
                              ),
                            );
                          },
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SalesEditScreen(
                                  vehicle: vehicle,
                                  isEditMode: true,
                                ),
                              ),
                            );
                          },
                          onDelete: ()async {
                            final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirm Delete'),
      content: Text('Are you sure you want to delete sale of ${saleInfo.name}?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
      ],
    ),
  );

  if (confirm == true) {
    // Call your delete logic here
    // e.g. ref.read(vehicleProvider.notifier).deleteSale(vehicle.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sale deleted successfully')),
    );
  }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
*/