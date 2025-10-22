import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/navigation/navigation_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:my_new_project/widgets/grid/grid_menu.dart';
import 'package:my_new_project/widgets/inventory/add_vehicle_form.dart';
import 'package:remixicon/remixicon.dart';


class BottomNavigationWidget extends ConsumerWidget {
  const BottomNavigationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current selected page index
    final selectedIndex = ref.watch(navigationProvider).currentIndex;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Icon 1
          IconButton(
            icon: Icon(
              selectedIndex == 0 ? Ionicons.home : Ionicons.home_outline,
              size: 25, // exactly like React
              color: selectedIndex == 0 ? Colors.blue : Colors.grey,
            ),
            onPressed: () {
              ref.read(navigationProvider.notifier).selectPage(0);
            },
          ),
          KHeight,
          // Vehicle (Bike)
//   IconButton(
//   icon: Image.asset(
//      'assets/images/cars/scooter.webp', // your image path
    
//     width: 26,  // set the size like a normal icon
//     height: 26,
//   ),
//   onPressed: () {
//     ref.read(navigationProvider.notifier).selectPage(1);
//   },
// )
IconButton(
  icon: Image.asset(
    selectedIndex == 1
        ? 'assets/images/cars/darkscooter.png' // active
        : 'assets/images/cars/scooter.png',     // inactive
     width: 26,
     height: 26,
  ),
  onPressed: () {
    ref.read(navigationProvider.notifier).selectPage(1);
  },
)


,


      

          // Add
          IconButton(
            icon: Icon(
              selectedIndex == 2 ? AntDesign.pluscircle : AntDesign.pluscircleo,
              size: 28,
              color: selectedIndex == 2 ? Colors.black : Colors.grey,
            ),
            onPressed: () {
Navigator.of(context).push(
  MaterialPageRoute(builder: (_)=>AddVehicleForm(
    onAddComplete:(){
       // ✅ refresh your vehicle provider after adding
          ref.read(vehicleProvider.notifier).loadVehicles();
    }
     ),
  )
);           },
          ),

          // Menu (Grid)
       IconButton(
  icon: Icon(
    selectedIndex == 3 ? Ionicons.grid : Ionicons.grid_outline,
    size: 25,
    color: selectedIndex == 3 ? Colors.black : Colors.grey,
  ),
  onPressed: () {
    ref.read(navigationProvider.notifier).selectPage(22); // just change index
  },
),



          // Settings
          IconButton(
            icon: Icon(
              selectedIndex == 4 ? Ionicons.settings : Ionicons.settings_outline,
              size: 25,
              color: selectedIndex == 4 ? Colors.black : Colors.grey,
            ),
            onPressed: () {
              ref.read(navigationProvider.notifier).selectPage(21);
            },
          ),


        ],
      ),
    );
  }
}
