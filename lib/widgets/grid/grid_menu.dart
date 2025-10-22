import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/navigation/navigation_provider.dart';
import 'package:my_new_project/widgets/grid/grid_menu_card.dart';


import 'package:remixicon/remixicon.dart';

class GridMenu extends ConsumerWidget {
  const GridMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Define your menu items with their icons, titles, and target page indexes
    final menuItems = [
  {'icon': Icons.shopping_cart, 'label': 'Sales', 'index': 2},
  {'icon': Icons.shopping_bag, 'label': 'Purchases', 'index': 3},
  {'icon': Icons.receipt_long, 'label': 'Expenses', 'index': 4},
  {'icon': Icons.notes, 'label': 'Expense Types', 'index': 5},
  {'icon': Icons.point_of_sale, 'label': 'Cash Book', 'index': 7},
  {'icon': Icons.account_balance_wallet, 'label': 'Account List', 'index': 12},
  {'icon': Icons.people, 'label': 'Employees', 'index': 15},
  {'icon': Icons.person_pin_circle, 'label': 'Employee Positions', 'index': null}, // No screen provided
  {'icon': Icons.payments, 'label': 'Payroll', 'index': 16},
  {'icon': Icons.person_add_alt_1, 'label': 'Attendance', 'index': 17},
  {'icon': Icons.account_balance, 'label': 'Financiers', 'index': 18},
  {'icon': Icons.account_balance, 'label': 'Finance', 'index': 10},
  {'icon': Icons.handshake, 'label': 'Brokers', 'index': 14},
  {'icon': Icons.apartment, 'label': 'Brokerage', 'index': 6},
  {'icon': Icons.handshake, 'label': 'Partners', 'index': 19},
  {'icon': Icons.group_add, 'label': 'Partnerships', 'index': 11},
  {'icon': Icons.currency_exchange, 'label': 'Advances', 'index': 13},
  {'icon': Icons.subscriptions, 'label': 'Subscriptions', 'index': 20},
  {'icon': Icons.bar_chart, 'label': 'Daily Summary', 'index': 9},
    {'icon':Icons.calendar_month, 'label': 'Monthly Summary', 'index': 8},

];


   return Padding(
  padding: const EdgeInsets.all(12.0),
  child: GridView.builder(
    physics: const BouncingScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.1,
    ),
    itemCount: menuItems.length,
    itemBuilder: (context, index) {
      final item = menuItems[index];
      return GridMenuCard(
        icon: item['icon'] as IconData,
        title: item['label'] as String,
        onTap: () {
          // Update navigation provider and go to that page
          if (item['index'] != null) {
            ref.read(navigationProvider.notifier).selectPage(item['index'] as int);
          }
        },
      );
    },
  ),
);

  }
}
