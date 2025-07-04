import 'package:flutter/material.dart';

import 'package:my_new_project/core/constants/constant.dart';

import 'package:my_new_project/presentation/main_page/widgets/bottom_nav.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_dashboard.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_inventory.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_report.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_sales.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_settings.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_tasks.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/main_drawer.dart';
import 'package:my_new_project/presentation/notifications/screen_notifications.dart';
import 'package:my_new_project/presentation/profile/screen_profile.dart';

class ScreenMainPage extends StatefulWidget {
  const ScreenMainPage({super.key});

  @override
  State<ScreenMainPage> createState() => _ScreenMainPageState();
}

class _ScreenMainPageState extends State<ScreenMainPage> {
  int _selectedDrawerIndex = 0;

  final List<Widget> _drawerPages = [
    ScreenDashboard(),
    ScreenInventory(),
    ScreenTasks(),
    ScreenSales(),
    ScreenReport(),
    ScreenSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const[
             Text(
          'AutoInventory',
          
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        KHeight,
        Text(
          'Vehicle Inventory',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey
          ),
        )
          ],
        ),
        
        
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(10),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
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
            padding: EdgeInsets.only(right: 2),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ScreenNotifications()),
                    );
                  },
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
        bottom: PreferredSize(preferredSize: Size.fromHeight(1),
         child: Container(
          color: Colors.grey.shade300,
          height: 1,
         )),
      ),
       
      drawer: MainDrawer(
        selectedIndex: _selectedDrawerIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedDrawerIndex = index;
          });
          Navigator.pop(context);
        },
      ),
      body: _drawerPages[_selectedDrawerIndex],
      // bottomNavigationBar: const BottomNavigationWidget(),
    );
  }
}
