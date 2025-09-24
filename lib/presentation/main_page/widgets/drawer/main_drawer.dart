// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_new_project/application/auth/auth_provider.dart';
// import 'package:my_new_project/core/constants/constant.dart';
// import 'package:my_new_project/core/constants/constant.dart';
// import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_dashboard.dart';
// import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_inventory.dart';
// import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_report.dart';
// import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_sales.dart';
// import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_settings.dart';
// import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_tasks.dart';

// class MainDrawer extends ConsumerWidget {
//   final int selectedIndex;
//   final Function(int) onItemSelected;

//   const MainDrawer({
//     super.key,
//     required this.selectedIndex,
//     required this.onItemSelected,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     void delayedNavigate(Widget screen) async {
//       await Future.delayed(Duration(milliseconds: 100));
//       Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
//     }

//     final user = ref.watch(authNotifierProvider).user;

//     return Drawer(
//       backgroundColor: Color(0xFF111330), // dark background

//       child: ListView(
//         padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
//         children: [
//           Text(
//             'Auto Inventory',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.blue,
//               fontSize: 24,
//             ),
//           ),
//           Text(
//             'Vehicle Management System',
//             style: TextStyle(
//               fontWeight: FontWeight.normal,
//               fontSize: 13,
//               color: Colors.grey,
//             ),
//           ),
//           KHeight,
//           const Divider(),

//           ListTile(
//             // splashColor: Colors.blueAccent,
//             // leading: Icon(Icons.dashboard),
//             // onTap: () => delayedNavigate(ScreenDashboard()),

//             // title: Text(
//             //   'Dashboard',
//             //   style: TextStyle(fontWeight: FontWeight.bold),
//             // ),
//             selected: selectedIndex == 0,
//             //  selectedTileColor: Colors.blue,
//             splashColor: Colors.blueAccent,
//             leading: Icon(
//               Icons.dashboard,
//               color: selectedIndex == 0 ? Colors.blue : null,
//             ),
//             title: Text(
//               'Dashboard',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 0 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(0),
//           ),
//           KHeight,

//           ListTile(
//             selected: selectedIndex == 1,
//             splashColor: Colors.blueAccent,
//             leading: Icon(
//               Icons.directions_car,
//               color: selectedIndex == 1 ? Colors.blue : null,
//             ),
//             title: Text(
//               'Inventory',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 1 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(1),
//           ),
//           KHeight,

//           ListTile(
//             selected: selectedIndex == 2,
//             splashColor: Colors.blueAccent,
//             leading: Icon(
//               Icons.shopping_cart,
//               color: selectedIndex == 2 ? Colors.blue : null,
//             ),
//             title: Text(
//               'Sales',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 2 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(2),
//           ),
//           KHeight,

//           ListTile(
//             selected: selectedIndex == 3,
//             splashColor: Colors.blueAccent,
//             leading: Icon(
//               Icons.shopping_bag,
//               color: selectedIndex == 3 ? Colors.blue : null,
//             ),
//             title: Text(
//               'Purchase',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 3 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(3),
//           ),
//           KHeight,

//           // KHeight,
//           ListTile(
//             selected: selectedIndex == 4,
//             splashColor: Colors.blueAccent,
//             leading: Icon(
//               Icons.person,
//               color: selectedIndex == 4 ? Colors.blue : null,
//             ),
//             title: Text(
//               'Employees',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 4 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(4),
//           ),
//           KHeight,

//           ListTile(
//             selected: selectedIndex == 5,
//             splashColor: Colors.blueAccent,
//             leading: Icon(
//               Icons.attach_money,
//               color: selectedIndex == 5 ? Colors.blue : null,
//             ),
//             title: Text(
//               'Expense',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 5 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(5),
//           ),
//           KHeight,

//           ListTile(
//             selected: selectedIndex == 6,
//             splashColor: Colors.blue,
//             leading: Icon(
//               Icons.group,
//               color: selectedIndex == 6 ? Colors.blueAccent : null,
//             ),
//             title: Text(
//               'Partners',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 6 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(6),
//           ),
//           KHeight,

//           // const Divider(),
//           ListTile(
//             selected: selectedIndex == 7,
//             splashColor: Colors.blueAccent,
//             leading: Icon(
//               Icons.bar_chart,
//               color: selectedIndex == 7 ? Colors.blue : null,
//             ),
//             title: Text(
//               'Brokers',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 7 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(7),
//           ),
//           KHeight,

//           ListTile(
//             selected: selectedIndex == 8,
//             splashColor: Colors.blueAccent,
//             leading: Icon(
//               Icons.factory,
//               color: selectedIndex == 8 ? Colors.blue : null,
//             ),
//             title: Text(
//               'Brokerage',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 8 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(8),
//           ),
//           KHeight,

//           ListTile(
//             selected: selectedIndex == 9,
//             splashColor: Colors.blueAccent,
//             leading: Icon(
//               Icons.account_balance,
//               color: selectedIndex == 9 ? Colors.blue : null,
//             ),
//             title: Text(
//               'Financiers',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 9 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(9),
//           ),
//           KHeight,

//           ListTile(
//             selected: selectedIndex == 10,
//             splashColor: Colors.blueAccent,
//             leading: Icon(
//               Icons.account_balance,
//               color: selectedIndex == 10 ? Colors.blue : null,
//             ),
//             title: Text(
//               'Finance',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 10 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(10),
//           ),
//           KHeight,

//           ListTile(
//             selected: selectedIndex == 11,
//             splashColor: Colors.blueAccent,
//             leading: Icon(
//               Icons.wallet,
//               color: selectedIndex == 11 ? Colors.blue : null,
//             ),
//             title: Text(
//               'Accounts',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 11 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(11),
//           ),
//           KHeight,

//           ListTile(
//             selected: selectedIndex == 12,
//             splashColor: Colors.blueAccent,
//             leading: Icon(
//               Icons.point_of_sale,
//               color: selectedIndex == 12 ? Colors.blue : null,
//             ),
//             title: Text(
//               'Cashbook',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 12 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(12),
//           ),
//           KHeight,

//           ListTile(
//             selected: selectedIndex == 13,
//             splashColor: Colors.blueAccent,
//             leading: Icon(
//               Icons.subscriptions,
//               color: selectedIndex == 13 ? Colors.blue : null,
//             ),
//             title: Text(
//               'Subscription',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 13 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(13),
//           ),
//           KHeight,

//           ListTile(
//             selected: selectedIndex == 14,
//             splashColor: Colors.blueAccent,
//             leading: Icon(
//               Icons.account_balance_wallet,
//               color: selectedIndex == 14 ? Colors.blue : null,
//             ),
//             title: Text(
//               'Advance',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 14 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(14),
//           ),
//           KHeight,

//           ListTile(
//             selected: selectedIndex == 15,
//             splashColor: Colors.blueAccent,
//             leading: Icon(
//               Icons.handshake,
//               color: selectedIndex == 15 ? Colors.blue : null,
//             ),
//             title: Text(
//               'Partnerships',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 15 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(15),
//           ),
//           KHeight,

//           ListTile(
//             selected: selectedIndex == 16,
//             splashColor: Colors.blueAccent,
//             leading: Icon(
//               Icons.bar_chart,
//               color: selectedIndex == 16 ? Colors.blue : null,
//             ),
//             title: Text(
//               'Reports',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 16 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(16),
//           ),
//           KHeight,

//           ListTile(
//             selected: selectedIndex == 17,
//             splashColor: Colors.blueAccent,
//             leading: Icon(
//               Icons.settings,
//               color: selectedIndex == 17 ? Colors.blue : null,
//             ),
//             title: Text(
//               'Settings',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 17 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(17),
//           ),
//           KHeight,

//           ListTile(
//             selected: selectedIndex == 18,
//             splashColor: Colors.blueAccent,
//             leading: Icon(
//               Icons.menu,
//               color: selectedIndex == 18 ? Colors.blue : null,
//             ),
//             title: Text(
//               'Expense Type',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == 18 ? Colors.blue : null,
//               ),
//             ),
//             onTap: () => onItemSelected(18),
//           ),

//           ExpansionTile(
//             leading: const Icon(Icons.insert_drive_file_outlined),
//             title: const Text(
//               'Summary',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             children: [
//               ListTile(
//                 selected: selectedIndex == 19, // ✅ highlight if active
//                 leading: Icon(
//                   Icons.calendar_today,
//                   color: selectedIndex == 19 ? Colors.blue : null,
//                 ),
//                 title: Text(
//                   'Monthly Summary',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: selectedIndex == 19 ? Colors.blue : null,
//                   ),
//                 ),
//                 onTap: () => onItemSelected(19),
//               ),
//               ListTile(
//                 selected: selectedIndex == 20, // ✅ highlight if active
//                 leading: Icon(
//                   Icons.bar_chart,
//                   color: selectedIndex == 20 ? Colors.blue : null,
//                 ),
//                 title: Text(
//                   'Daily Summary',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: selectedIndex == 20 ? Colors.blue : null,
//                   ),
//                 ),
//                 onTap: () => onItemSelected(20),
//               ),
//             ],
//           ),

//           SizedBox(height: MediaQuery.of(context).size.height * 0.3),
//           const Divider(),

//           ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.blue.withOpacity(0.6),
//               child: Text(
//                 (user?.username.isNotEmpty ?? false)
//                     ? user!.username[0].toUpperCase()
//                     : 'U',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue[900],
//                 ),
//               ),
//             ),
//             title: Text(
//               user?.username ?? 'Unknown User',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(user?.username ?? 'No UserName'),
//           ),

//           KHeight16,
//           ListTile(
//             leading: const Icon(Icons.logout),
//             title: const Text('Logout'),
//             onTap: () {
//               ref
//                   .read(authNotifierProvider.notifier)
//                   .logout(); // ✅ Clears memory + Hive

//               // ✅ Routes to Login screen
//               Navigator.of(context).pushReplacementNamed('/login');
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/reusable/custom_drawer_item.dart';

class MainDrawer extends ConsumerWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const MainDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
