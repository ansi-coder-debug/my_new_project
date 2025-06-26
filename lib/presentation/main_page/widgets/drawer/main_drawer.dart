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
            leading: Icon(Icons.dashboard),
            title: Text(
              'Dashboard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text(
              'Inventory',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.task),
            title: Text('Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('Sales', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          KHeight,
          const Divider(),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text(
              'Reports',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
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
