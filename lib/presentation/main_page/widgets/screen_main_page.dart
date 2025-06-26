import 'package:flutter/material.dart';

import 'package:my_new_project/presentation/main_page/widgets/bottom_nav.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/main_drawer.dart';
import 'package:my_new_project/presentation/notifications/screen_notifications.dart';
import 'package:my_new_project/presentation/profile/screen_profile.dart';

class ScreenMainPage extends StatelessWidget {
  const ScreenMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AutoInventory',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: const BottomNavigationWidget(),
    );
  }
}
