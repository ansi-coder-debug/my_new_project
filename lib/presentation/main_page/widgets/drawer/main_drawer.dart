import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_dashboard.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_inventory.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_report.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_sales.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_settings.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_tasks.dart';

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
    void delayedNavigate(Widget screen) async {
      await Future.delayed(Duration(milliseconds: 100));
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    }

    final user = ref.watch(authNotifierProvider).user;

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        children: [
          Text(
            'Auto Inventory',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontSize: 24,
            ),
          ),
          Text(
            'Vehicle Management System',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          KHeight,
          const Divider(),

          ListTile(
            // splashColor: Colors.blueAccent,
            // leading: Icon(Icons.dashboard),
            // onTap: () => delayedNavigate(ScreenDashboard()),

            // title: Text(
            //   'Dashboard',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            selected: selectedIndex == 0,
            //  selectedTileColor: Colors.blue,
            splashColor: Colors.blueAccent,
            leading: Icon(
              Icons.dashboard,
              color: selectedIndex == 0 ? Colors.blue : null,
            ),
            title: Text(
              'Dashboard',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == 0 ? Colors.blue : null,
              ),
            ),
            onTap: () => onItemSelected(0),
          ),
          ListTile(
            // leading: Icon(Icons.directions_car),
            // splashColor: Colors.blue,
            // onTap: () => delayedNavigate(ScreenInventory()),
            // title: Text(
            //   'Inventory',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            selected: selectedIndex == 1,
            splashColor: Colors.blueAccent,
            leading: Icon(
              Icons.directions_car,
              color: selectedIndex == 1 ? Colors.blue : null,
            ),
            title: Text(
              'Inventory',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == 1 ? Colors.blue : null,
              ),
            ),
            onTap: () => onItemSelected(1),
          ),
          ListTile(
            // leading: Icon(Icons.task),
            // splashColor: Colors.blue,
            // onTap: () => delayedNavigate(ScreenTasks()),
            // title: Text('Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
            selected: selectedIndex == 2,
            splashColor: Colors.blueAccent,
            leading: Icon(
              Icons.shopping_cart,
              color: selectedIndex == 2 ? Colors.blue : null,
            ),
            title: Text(
              'Purchase',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == 2 ? Colors.blue : null,
              ),
            ),
            onTap: () => onItemSelected(2),
          ),
          ListTile(
            // leading: Icon(Icons.attach_money),
            // splashColor: Colors.blue,
            // onTap: () => delayedNavigate(ScreenSales()),
            // title: Text('Sales', style: TextStyle(fontWeight: FontWeight.bold)),
            selected: selectedIndex == 3,
            splashColor: Colors.blueAccent,
            leading: Icon(
              Icons.attach_money,
              color: selectedIndex == 3 ? Colors.blue : null,
            ),
            title: Text(
              'Sales',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == 3 ? Colors.blue : null,
              ),
            ),
            onTap: () => onItemSelected(3),
          ),

          // KHeight,
          ListTile(
            selected: selectedIndex == 4,
            splashColor: Colors.blueAccent,
            leading: Icon(
              Icons.person,
              color: selectedIndex == 4 ? Colors.blue : null,
            ),
            title: Text(
              'Employees',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == 4 ? Colors.blue : null,
              ),
            ),
            onTap: () => onItemSelected(4),
          ),

          ListTile(
            selected: selectedIndex == 5,
            splashColor: Colors.blueAccent,
            leading: Icon(
              Icons.attach_money,
              color: selectedIndex == 5 ? Colors.blue : null,
            ),
            title: Text(
              'Expense',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == 5 ? Colors.blue : null,
              ),
            ),
            onTap: () => onItemSelected(5),
          ),

          ListTile(
            selected: selectedIndex == 6,
            splashColor: Colors.blue,
            leading: Icon(
              Icons.group,
              color: selectedIndex == 6 ? Colors.blueAccent : null,
            ),
            title: Text(
              'Partnerships',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == 6 ? Colors.blue : null,
              ),
            ),
            onTap: () => onItemSelected(6),
          ),

          const Divider(),

          ListTile(
            selected: selectedIndex == 7,
            splashColor: Colors.blueAccent,
            leading: Icon(
              Icons.bar_chart,
              color: selectedIndex == 7 ? Colors.blue : null,
            ),
            title: Text(
              'Reports',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == 7 ? Colors.blue : null,
              ),
            ),
            onTap: () => onItemSelected(7),
          ),

          ListTile(
            // leading: Icon(Icons.settings),
            // splashColor: Colors.blue,
            // onTap: () => delayedNavigate(ScreenSettings()),
            // title: Text(
            //   'Settings',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            selected: selectedIndex == 8,
            splashColor: Colors.blueAccent,
            leading: Icon(
              Icons.settings,
              color: selectedIndex == 8 ? Colors.blue : null,
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == 8 ? Colors.blue : null,
              ),
            ),
            onTap: () => onItemSelected(8),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          const Divider(),

          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.6),
              child: Text(
                (user?.username.isNotEmpty ?? false)
                    ? user!.username[0].toUpperCase()
                    : 'U',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
            ),
            title: Text(
              user?.username ?? 'Unknown User',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(user?.username ?? 'No UserName'),
          ),

          KHeight16,
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              ref
                  .read(authNotifierProvider.notifier)
                  .logout(); // ✅ Clears memory + Hive

              // ✅ Routes to Login screen
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
    );
  }
}
