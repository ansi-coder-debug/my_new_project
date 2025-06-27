import 'package:flutter/material.dart';
import 'package:my_new_project/core/constant.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_dashboard.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_inventory.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_report.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_sales.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_settings.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_tasks.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  

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
            splashColor: Colors.blueAccent,
            leading: Icon(Icons.dashboard),
            onTap: () => delayedNavigate (ScreenDashboard()),

            title: Text(
              'Dashboard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),


          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            splashColor: Colors.blue,
            onTap: () => delayedNavigate(ScreenInventory()),
            title: Text(
              'Inventory',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.task),
            splashColor: Colors.blue,
            onTap: () =>delayedNavigate(ScreenTasks()),
            title: Text('Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            splashColor: Colors.blue,
            onTap: ()=>delayedNavigate(ScreenSales()),
            title: Text('Sales', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          KHeight,
          const Divider(),
          ListTile(
            leading: Icon(Icons.bar_chart),
            splashColor: Colors.blue,
            onTap: () =>delayedNavigate(ScreenReport()),
            title: Text(
              'Reports',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            splashColor: Colors.blue,
            onTap: ()=> delayedNavigate(ScreenSettings()),
            title: Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
