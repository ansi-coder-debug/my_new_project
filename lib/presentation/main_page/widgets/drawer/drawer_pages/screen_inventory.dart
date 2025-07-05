import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/add_vehicle_form.dart';
import 'package:my_new_project/presentation/main_page/widgets/inventory_vehicle_card.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/add_vehicle_form.dart';

//  Text('Inventory'),
class ScreenInventory extends StatefulWidget {
  const ScreenInventory({super.key});

  @override
  State<ScreenInventory> createState() => _ScreenInventoryState();
}

class _ScreenInventoryState extends State<ScreenInventory> {
  String selectedStatus = 'All Status';
  String selectedSort = 'Newest First';
  bool showAddForm = false;
  Vehicle? vehicleToEdit;

  final Box<Vehicle> vehicleBox = Hive.box<Vehicle>('vehicles');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showAddForm ? 'Add New Vehicle' : 'Inventory'),
      ),

      body: showAddForm
          ? AddVehicleForm(
              onCancel: () {
                setState(() {
                  showAddForm = false;
                });
              },
              onAddComplete: () {
                setState(() {
                  showAddForm = false;
                });
              },
              vehicleToEdit: vehicleToEdit,
            )
          : ValueListenableBuilder(
              valueListenable: Hive.box<Vehicle>('vehicles').listenable(),
              builder: (context, box, _) {
                //getting all vehicles
                List<Vehicle> vehicles = box.values.toList();
                List<int> Keys = box.keys
                    .cast<int>()
                    .toList(); //calling delete from the hive and refresh ui

                //apply filter by status
                if (selectedStatus != 'All Status') {
                  vehicles = vehicles
                      .where((v) => v.status == selectedStatus)
                      .toList();
                }

                vehicles.sort((a, b) {
                  switch (selectedSort) {
                    case 'Newest First': //high means b
                      return b.year.compareTo(a.year); // low means a

                    case 'Oldest First':
                      return a.year.compareTo(b.year);

                    case 'Price High To Low':
                      return int.parse(
                        b.price.replaceAll(',', ''),
                      ).compareTo(int.parse(a.price.replaceAll(',', '')));

                    case 'Price Low To High':
                      return int.parse(
                        a.price.replaceAll(',', ''),
                      ).compareTo(int.parse(b.price.replaceAll(',', '')));
                    default:
                      return 0;
                  }
                });
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(26),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Vehicles',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (query) {
                          setState(() {
                            // Optional: Add search functionality if you want
                          });
                        },
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: selectedStatus,
                              decoration: const InputDecoration(
                                // labelText: 'Status',
                                border: OutlineInputBorder(),
                              ),

                              items:
                                  [
                                    'All Status',
                                    'Available',
                                    'Pending Sale',
                                    'Sold',
                                    'In Maintenance',
                                  ].map((status) {
                                    return DropdownMenuItem(
                                      value: status,
                                      child: Text(status),
                                    );
                                  }).toList(),

                              onChanged: (value) {
                                setState(() {
                                  selectedStatus = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: selectedSort,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              items:
                                  [
                                    'Newest First',
                                    'Oldest First',
                                    'Price High to Low',
                                    'Price Low to High',
                                  ].map((sortOption) {
                                    return DropdownMenuItem(
                                      value: sortOption,
                                      child: Text(sortOption),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedSort = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton.icon(
                            icon: Icon(Icons.add),
                            label: Text('Add'),
                            onPressed: () {
                              setState(() {
                                vehicleToEdit = null;
                                showAddForm = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: vehicles.isEmpty
                          ? Center(child: Text('No Vehicle Found'))
                          : ListView.builder(
                              itemCount: vehicles.length,
                              itemBuilder: (context, index) {
                                final Vehicle = vehicles[index];

                                return InventoryVehicleCard(
                                  title: Vehicle.title,
                                  imageUrl: Vehicle.imageUrl,
                                  price: Vehicle.price,
                                  mileage: Vehicle.mileage,
                                  color: Vehicle.color,
                                  vin: Vehicle.vin,
                                  task: Vehicle.task,
                                  status: Vehicle.status,
                                  year: Vehicle.year,
                                  onDelete: () {
                                    final Key = Keys[index]; //key list
                                    vehicleBox.delete(
                                      Key,
                                    ); //delete from hive storage
                                    setState(() {}); // update ui
                                  },
                                  onEdit: () {
                                    setState(() {
                                      vehicleToEdit = vehicles[index];
                                      showAddForm = true;
                                    });
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
      //

                
                
              

//             

//                  
                 
                 
//                  
//               },
              
//               ),
//             ),
//     );
//   }
// }


/*

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/add_vehicle_form.dart';
import 'package:my_new_project/presentation/main_page/widgets/inventory_vehicle_card.dart';

class ScreenInventory extends StatefulWidget {
  const ScreenInventory({super.key});

  @override
  State<ScreenInventory> createState() => _ScreenInventoryState();
}

class _ScreenInventoryState extends State<ScreenInventory> {
  String selectedStatus = 'All Status';
  String selectedSort = 'Newest First';
  bool showAddForm = false;

  final Box<Vehicle> vehicleBox = Hive.box<Vehicle>('vehicles');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showAddForm ? 'Add New Vehicle' : 'Inventory'),
      ),
      body: showAddForm
          ? AddVehicleForm(
              // If you want, add a callback to close form
              // onCancel: () => setState(() => showAddForm = false),
            )
          : ValueListenableBuilder(
              valueListenable: vehicleBox.listenable(),
              builder: (context, Box<Vehicle> box, _) {
                // ✅ 1. Get all vehicles
                List<Vehicle> vehicles = box.values.toList();

                // ✅ 2. Apply filter by status
                if (selectedStatus != 'All Status') {
                  vehicles = vehicles
                      .where((v) => v.status == selectedStatus)
                      .toList();
                }

                // ✅ 3. Apply sort
                vehicles.sort((a, b) {
                  switch (selectedSort) {
                    case 'Newest First':
                      return b.vin.compareTo(a.vin); // Replace with year if you have
                    case 'Oldest First':
                      return a.vin.compareTo(b.vin);
                    case 'Price High to Low':
                      return int.parse(b.price.replaceAll(',', ''))
                          .compareTo(int.parse(a.price.replaceAll(',', '')));
                    case 'Price Low to High':
                      return int.parse(a.price.replaceAll(',', ''))
                          .compareTo(int.parse(b.price.replaceAll(',', '')));
                    default:
                      return 0;
                  }
                });

                return Column(
                  children: [
                    // ✅ Search bar
                    Padding(
                      padding: const EdgeInsets.all(26),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Vehicles',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (query) {
                          setState(() {
                            // Optional: Add search functionality if you want
                          });
                        },
                      ),
                    ),

                    // ✅ Dropdowns & Add button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: selectedStatus,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              items: [
                                'All Status',
                                'Available',
                                'Pending Sale',
                                'Sold',
                                'In Maintenance',
                              ].map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedStatus = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: selectedSort,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              items: [
                                'Newest First',
                                'Oldest First',
                                'Price High to Low',
                                'Price Low to High',
                              ].map((sortOption) {
                                return DropdownMenuItem(
                                  value: sortOption,
                                  child: Text(sortOption),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedSort = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton.icon(
                            icon: Icon(Icons.add),
                            label: Text('Add'),
                            onPressed: () {
                              setState(() {
                                showAddForm = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ✅ Vehicles list
                    Expanded(
                      child: vehicles.isEmpty
                          ? Center(child: Text('No vehicles found.'))
                          : ListView.builder(
                              itemCount: vehicles.length,
                              itemBuilder: (ctx, index) {
                                final vehicle = vehicles[index];
                                return InventoryVehicleCard(
                                  title: vehicle.title,
                                  imageUrl: vehicle.imageUrl,
                                  year: vehicle.year,
                                  price: vehicle.price,
                                  mileage: vehicle.mileage,
                                  color: vehicle.color,
                                  vin: vehicle.vin,
                                  task: vehicle.task,
                                  status: vehicle.status,
                                );
                              },
                            ),
                    ),
                  ],
                );
              },












            ),
    );
  }
}

  // final List<Map<String, String>> allVehicles = [
  //   {
  //     'title': '2021 Chevrolet Equinox',
  //     'year': '2021',
  //     'imageUrl': 'assets/images/cars/chevrolet_equinox.webp',
  //     'price': '25,500',
  //     'mileage': '18,000 mi',
  //     'color': 'Red',
  //     'vin': '123456',
  //     'task': '2',
  //     'status': 'In Maintenance',
  //   },

  // final vehicles = box.values.toList();
  //               return ListView.builder(
  //                 itemCount: vehicles.length,
  //                 itemBuilder: (ctx, index) => InventoryVehicleCard(
  //                   title: vehicles[index].title,
  //                   imageUrl:vehicles[index].imageUrl,
  //                   price: vehicles[index].price,
  //                   mileage: vehicles[index].mileage,
  //                   color: vehicles[index].color,
  //                   vin: vehicles[index].vin,
  //                   task: vehicles[index].task,
  //                   status: vehicles[index].status,
  //                 ),
  //               );
  */


//   Scaffold
//  ├── AppBar
//  └── Body: 
//      └── ValueListenableBuilder
//          └── Column
//              ├── Padding (Search bar)
//              ├── Padding (Dropdowns & Add button)
//              └── Expanded
//                  └── ListView.builder
