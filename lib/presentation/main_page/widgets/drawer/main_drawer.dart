
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';
import 'package:my_new_project/application/navigation/navigation_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/reusable/custom_drawer_item.dart';

class MainDrawer extends ConsumerWidget {
  // final int selectedIndex;
  final Function(int) onItemSelected;

  const MainDrawer({
    super.key,
    // required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
        final selectedIndex = ref.watch(navigationProvider).currentIndex; // now global

    final user = ref.watch(authNotifierProvider).user;

    return Drawer(
      backgroundColor: const Color(0xFF111330),
      child: Column(
        children: [
          // 🔼 Main scrollable content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 00, left: 10, right: 10),
              children: [
                // App title
               Padding(
  padding: const EdgeInsets.only(top: 40.0, bottom: 20),
  child: Center(
    child: Transform(
      transform: Matrix4.diagonal3Values(1.5, 1.0, 1),
      alignment: Alignment.center,
      child: const Text(
        'WheelX',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          // letterSpacing: 1.2,
        ),
      ),
    ),
  ),
),

             

                // Drawer Items
                CustomDrawerItem(
                  title: "Dashboard",
                  icon: Icons.dashboard,
                  selected: selectedIndex == 0,
                  onTap: () => onItemSelected(0),
                ),
                CustomDrawerItem(
                  title: "Vehicles",
                  icon: Icons.directions_car,
                  selected: selectedIndex == 1,
                  onTap: () => onItemSelected(1),
                ),
                CustomDrawerItem(
                  title: "Sales",
                  icon: Icons.shopping_cart,
                  selected: selectedIndex == 2,
                  onTap: () => onItemSelected(2),
                ),
                CustomDrawerItem(
                  title: "Purchase",
                  icon: Icons.shopping_bag,
                  selected: selectedIndex == 3,
                  onTap: () => onItemSelected(3),
                ),

                // Expenses
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    key: const PageStorageKey('ExpensesTile'),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    childrenPadding: const EdgeInsets.only(left: 28.0),
                    title: const Text(
                      "Expenses",
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: const Icon(
                      Icons.receipt_long,
                      color: Colors.white,
                    ),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    collapsedBackgroundColor: Colors.transparent,
                    children: [
                      CustomDrawerItem(
                        title: "Expenses",
                        icon: Icons.attach_money,
                        selected: selectedIndex == 4,
                        onTap: () => onItemSelected(4),
                      ),
                      CustomDrawerItem(
                        title: "Expense Type",
                        icon: Icons.menu,
                        selected: selectedIndex == 5,
                        onTap: () => onItemSelected(5),
                      ),
                    ],
                  ),
                ),

                // Reports
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                      key: const PageStorageKey('ReportsTile'),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    childrenPadding: const EdgeInsets.only(left: 32.0),
                    title: const Text(
                      "Reports",
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: const Icon(Icons.bar_chart, color: Colors.white),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    collapsedBackgroundColor: Colors.transparent,
                    children: [
                      CustomDrawerItem(
                        title: "Brokerage",
                        icon: Icons.factory,
                        selected: selectedIndex == 6,
                        onTap: () => onItemSelected(6),
                      ),
                      CustomDrawerItem(
                        title: "Cashbook",
                        icon: Icons.book,
                        selected: selectedIndex == 7,
                        onTap: () => onItemSelected(7),
                      ),
                      // Summary (nested)
                      Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                            key: const PageStorageKey('SummaryTile'),
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          childrenPadding: const EdgeInsets.only(left: 32.0),
                          title: const Text(
                            "Summary",
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: const Icon(
                            Icons.insert_drive_file,
                            color: Colors.white,
                          ),
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          backgroundColor: Colors.transparent,
                          collapsedBackgroundColor: Colors.transparent,
                          children: [
                            CustomDrawerItem(
                              title: "Monthly Summary",
                              icon: Icons.calendar_today,
                              selected: selectedIndex == 8,
                              onTap: () => onItemSelected(8),
                            ),
                            CustomDrawerItem(
                              title: "Daily Summary",
                              icon: Icons.bar_chart,
                              selected: selectedIndex == 9,
                              onTap: () => onItemSelected(9),
                            ),
                          ],
                        ),
                      ),
                      CustomDrawerItem(
                        title: "Finance",
                        icon: Icons.account_balance,
                        selected: selectedIndex == 10,
                        onTap: () => onItemSelected(10),
                      ),
                      CustomDrawerItem(
                        title: "Partnerships",
                        icon: Icons.handshake,
                        selected: selectedIndex == 11,
                        onTap: () => onItemSelected(11),
                      ),
                    ],
                  ),
                ),

                // List
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                      key: const PageStorageKey('ListTile'),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    childrenPadding: const EdgeInsets.only(left: 32.0),
                    title: const Text(
                      "List",
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: const Icon(Icons.list, color: Colors.white),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    collapsedBackgroundColor: Colors.transparent,
                    children: [
                      CustomDrawerItem(
                        title: "Account",
                        icon: Icons.wallet,
                        selected: selectedIndex == 12,
                        onTap: () => onItemSelected(12),
                      ),
                      CustomDrawerItem(
                        title: "Advance",
                        icon: Icons.account_balance_wallet,
                        selected: selectedIndex == 13,
                        onTap: () => onItemSelected(13),
                      ),
                      CustomDrawerItem(
                        title: "Broker",
                        icon: Icons.bar_chart,
                        selected: selectedIndex == 14,
                        onTap: () => onItemSelected(14),
                      ),
                      // Employees (nested)
                      Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                            key: const PageStorageKey('EmployeesTile'),
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          childrenPadding: const EdgeInsets.only(left: 32.0),
                          title: const Text(
                            "Employees",
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: const Icon(
                            Icons.people,
                            color: Colors.white,
                          ),
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          backgroundColor: Colors.transparent,
                          collapsedBackgroundColor: Colors.transparent,
                          children: [
                            CustomDrawerItem(
                              title: "Employees",
                              icon: Icons.person,
                              selected: selectedIndex == 15,
                              onTap: () => onItemSelected(15),
                            ),
                            CustomDrawerItem(
                              title: "Payroll",
                              icon: Icons.payments,
                              selected: selectedIndex == 16,
                              onTap: () => onItemSelected(16),
                            ),
                            CustomDrawerItem(
                              title: "Attendance",
                              icon: Icons.calendar_today,
                              selected: selectedIndex == 17,
                              onTap: () => onItemSelected(17),
                            ),
                          ],
                        ),
                      ),
                      CustomDrawerItem(
                        title: "Financier",
                        icon: Icons.account_balance,
                        selected: selectedIndex == 18,
                        onTap: () => onItemSelected(18),
                      ),
                      CustomDrawerItem(
                        title: "Partner",
                        icon: Icons.handshake,
                        selected: selectedIndex == 19,
                        onTap: () => onItemSelected(19),
                      ),
                    ],
                  ),
                ),

                CustomDrawerItem(
                  title: "Subscription",
                  icon: Icons.subscriptions,
                  selected: selectedIndex == 20,
                  onTap: () => onItemSelected(20),
                ),
                CustomDrawerItem(
                  title: "Settings",
                  icon: Icons.settings,
                  selected: selectedIndex == 21,
                  onTap: () => onItemSelected(21),
                ),
              ],
            ),
          ),

          // 🔽 Bottom pinned section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // ListTile(
                //   leading: CircleAvatar(
                //     backgroundColor: Colors.blue.withOpacity(0.6),
                //     child: Text(
                //       (user?.username.isNotEmpty ?? false)
                //           ? user!.username[0].toUpperCase()
                //           : 'U',
                //       style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         color: Colors.blue[900],
                //       ),
                //     ),
                //   ),
                //   title: Text(
                //     user?.username ?? 'Unknown User',
                //     style: const TextStyle(
                //       color: Colors.white,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                //   subtitle: Text(
                //     user?.username ?? 'No UserName',
                //     style: const TextStyle(color: Colors.grey),
                //   ),
                // ),
                CustomDrawerItem(
                  title: "Logout",
                  icon: Icons.logout,
                  selected: false,
                  onTap: () {
                    ref.read(authNotifierProvider.notifier).logout();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
