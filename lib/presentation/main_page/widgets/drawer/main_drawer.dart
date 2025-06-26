// import 'package:flutter/material.dart';
// import 'package:my_new_project/core/constant.dart';

// class MainDrawer extends StatelessWidget {
//   const MainDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Padding(
//         padding: EdgeInsets.only(top: 40, left: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Auto Inventory',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//                 fontSize: 24,
//               ),
//             ),
//             const Text(
//               'Vehicle Management System',
//               style: TextStyle(
//                 fontWeight: FontWeight.normal,
//                 fontSize: 13,
//                 color: Colors.grey,
//               ),
//             ),
//             KHeight30,
//             ListTile(
//               leading: Icon(Icons.dashboard),
//                   title:Text('Dashboard',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold
//                   ),) ,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
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
            leading:
               Icon(Icons.dashboard),
              onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_)=>ScreenDashboard())
              );
            },
            
            title: Text(
              'Dashboard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
             onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_)=>ScreenInventory())
              );
            },
            title: Text(
              'Inventory',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.task),
             onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_)=>ScreenTasks())
              );
            },
            title: Text('Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
             onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_)=>ScreenSales())
              );
            },
            title: Text('Sales', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          KHeight,
          const Divider(),
          ListTile(
            leading: Icon(Icons.bar_chart),
             onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_)=>ScreenReport())
              );
            },
            title: Text(
              'Reports',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
             onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_)=>ScreenSettings())
              );
            },
            title: Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.bold,
              ),
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
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
              
            ),
            subtitle: Text(
              'admin@example.com'
            ),
          ),
        ],
      ),
    );
  }
}
