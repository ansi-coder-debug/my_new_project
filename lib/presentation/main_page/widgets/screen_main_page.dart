import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/navigation/navigation_provider.dart';

import 'package:my_new_project/core/constants/constant.dart';

import 'package:my_new_project/presentation/main_page/widgets/bottom_nav.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_accounts.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_advance.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_attendance.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_brokerage.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_brokers.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_cashbook.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_daily_summary.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_dashboard.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_employees.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_expense.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_expensetype.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_finance.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_financiers.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_inventory.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_monthly_summary.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_partners.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_partnerships.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_payroll.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_purchase.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_report.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_sales.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_settings.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_subscription.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_tasks.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/main_drawer.dart';
import 'package:my_new_project/presentation/notifications/screen_notifications.dart';
import 'package:my_new_project/presentation/profile/screen_profile.dart';
import 'package:my_new_project/widgets/grid/grid_menu.dart';
import 'package:my_new_project/widgets/settings/profile_settings.dart';

class ScreenMainPage extends ConsumerStatefulWidget {
  const ScreenMainPage({super.key});

  @override
  ConsumerState<ScreenMainPage> createState() => _ScreenMainPageState();
}

class _ScreenMainPageState extends ConsumerState<ScreenMainPage> {
 
  String? _inventoryStatus; // 👈 track status like "Available", "Sold"

  // int _selectedDrawerIndex = 0;

  // List<Widget> get _drawerPages => [
  late final List<Widget> _drawerPages;

//   @override
//   void initState() {
//     super.initState();

//     _drawerPages = [
//       ScreenDashboard(
        
//         onCardTap: (int index, {String? status}) {
//           ref.read(navigationProvider.notifier).selectPage(index);
//           // Only set _inventoryStatus for index 1 (Vehicles)
//           if (index == 1) {       
//  ref.read(inventoryStatusProvider.notifier).state =
//                 status ?? 'Available';
          
//           } 
//         },
//       ),
//         // Use Consumer here to rebuild when inventoryStatus changes
//       // Consumer(
//       //   builder: (context, ref, _) {
//       //     final status = ref.watch(inventoryStatusProvider);
//       //     return ScreenInventory(
//       //       key: ValueKey(status), // ensures rebuild on status change
//       //       initialStatus: status,
//       //     );
//       //   },
//       // ),

//       ScreenInventory(initialStatus: _inventoryStatus), // 1: Vehicles
//       ScreenSales(), // 2: Sales
//       ScreenPurchase(), // 3: Purchase
//       ScreenExpense(), // 4: Expenses
//       ScreenExpenseTypes(), // 5: Expense Type
//       ScreenBrokerage(), // 6: Brokerage
//       ScreenCashbook(), // 7: Cashbook
//       ScreenMonthlySummary(), // 8: Monthly Summary
//       ScreenDailySummary(), // 9: Daily Summary
//       ScreenFinance(), // 10: Finance
//       ScreenPartnerships(), // 11: Partnerships
//       ScreenAccounts(), // 12: Account
//       ScreenAdvance(), // 13: Advance
//       ScreenBrokers(), // 14: Broker
//       ScreenEmployees(), // 15: Employees
//       ScreenPayroll(), // 16: Payroll
//       ScreenAttendance(), // 17: Attendance
//       ScreenFinanciers(), // 18: Financier
//       PartnersPage(), // 19: Partner
//       ScreenSubscription(), // 20: Subscription
//       ScreenSettings(), // 21: Settings
//       GridMenu(),  // 22:gridmenu
//       ProfileSettingsPage(), // 23:profile seetings  
//       // ];
//     ];
//   }

@override
void initState() {
  super.initState();
}

/// ✅ Only build the selected page when needed
Widget _getDrawerPage(int index) {
  switch (index) {
    case 0:
      return ScreenDashboard(
        onCardTap: (int index, {String? status}) {
          ref.read(navigationProvider.notifier).selectPage(index);
          if (index == 1) {
            ref.read(inventoryStatusProvider.notifier).state =
                status ?? 'Available';
          }
        },
      );
    case 1:
      return ScreenInventory(initialStatus: _inventoryStatus);
    case 2:
      return ScreenSales();
    case 3:
      return ScreenPurchase();
    case 4:
      return ScreenExpense();
    case 5:
      return ScreenExpenseTypes();
    case 6:
      return ScreenBrokerage();
    case 7:
      return ScreenCashbook();
    case 8:
      return ScreenMonthlySummary();
    case 9:
      return ScreenDailySummary();
    case 10:
      return ScreenFinance();
    case 11:
      return ScreenPartnerships();
    case 12:
      return ScreenAccounts();
    case 13:
      return ScreenAdvance();
    case 14:
      return ScreenBrokers();
    case 15:
      return ScreenEmployees();
    case 16:
      return ScreenPayroll();
    case 17:
      return ScreenAttendance();
    case 18:
      return ScreenFinanciers();
    case 19:
      return PartnersPage();
    case 20:
      return ScreenSubscription();
    case 21:
      return ScreenSettings();
    case 22:
      return GridMenu();
    case 23:
      return ProfileSettingsPage();
    default:
      return const Center(child: Text("Unknown Page"));
  }
}




  @override
  Widget build(BuildContext context) {
     final companyName = ref.watch(companyNameProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children:  [
            Text(
             companyName , // reactive company name
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),

        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(10),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              child: IconButton(
                icon: const Icon(Icons.menu),
                iconSize: 20,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ),
        ),

        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.person_2_outlined),
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => ScreenProfile()));
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
      ),

      drawer: MainDrawer(
        // selectedIndex: ref.watch(navigationProvider).currentIndex,
        onItemSelected: (index) {
          setState(() {
            ref.read(navigationProvider.notifier).selectPage(index);
          });
          Navigator.pop(context);
        },
      ),
      // body: _drawerPages[ref.watch(navigationProvider).currentIndex],
//       body: IndexedStack(
//   index: ref.watch(navigationProvider).currentIndex,
//   children: _drawerPages,
// ),



body: _getDrawerPage(ref.watch(navigationProvider).currentIndex),



      bottomNavigationBar: const BottomNavigationWidget(),
    );
  }
}



