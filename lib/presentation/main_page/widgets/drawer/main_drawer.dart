import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_dashboard.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_inventory.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_report.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_sales.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_settings.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_tasks.dart';

class MainDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const MainDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    void delayedNavigate(Widget screen) async {
      await Future.delayed(Duration(milliseconds: 100));
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    }

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
              Icons.task,
              color: selectedIndex == 2 ? Colors.blue : null,
            ),
            title: Text(
              'Tasks',
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
          KHeight,
          const Divider(),
          ListTile(
            // leading: Icon(Icons.bar_chart),
            // splashColor: Colors.blue,
            // onTap: () => delayedNavigate(ScreenReport()),
            // title: Text(
            //   'Reports',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            selected: selectedIndex == 4,
            splashColor: Colors.blueAccent,
            leading: Icon(
              Icons.bar_chart,
              color: selectedIndex == 4 ? Colors.blue : null,
            ),
            title: Text(
              'Reports',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == 4 ? Colors.blue : null,
              ),
            ),
            onTap: () => onItemSelected(4),
          ),

          ListTile(
            // leading: Icon(Icons.settings),
            // splashColor: Colors.blue,
            // onTap: () => delayedNavigate(ScreenSettings()),
            // title: Text(
            //   'Settings',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            selected: selectedIndex == 5,
            splashColor: Colors.blueAccent,
            leading: Icon(
              Icons.settings,
              color: selectedIndex == 5 ? Colors.blue : null,
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == 5 ? Colors.blue : null,
              ),
            ),
            onTap: () => onItemSelected(5),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          const Divider(),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.6),
              child: Text(
                'A',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
            ),
            title: Text(
              'Admin User',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('admin@example.com'),
          ),
        ],
      ),
    );
  }
}
