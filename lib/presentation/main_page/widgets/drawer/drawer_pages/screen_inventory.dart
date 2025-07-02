import 'package:flutter/material.dart';
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

  final List<Map<String, String>> allVehicles = [
    {
      'title': '2021 Chevrolet Equinox',
      'year': '2021',
      'imageUrl': 'assets/images/cars/chevrolet_equinox.webp',
      'price': '25,500',
      'mileage': '18,000 mi',
      'color': 'Red',
      'vin': '123456',
      'task': '2',
      'status': 'In Maintenance',
    },
    {
      'title': '2021 Honda Civic',
      'year': '2021',
      'imageUrl': 'assets/images/cars/hondacivic.jpg',
      'price': '21,000',
      'mileage': '15,000 mi',
      'color': 'Blue',
      'vin': '123456',
      'task': '1',
      'status': 'Pending Sale',
    },
    {
      'title': '2020 Toyota Camry',
      'year': '2020',
      'imageUrl': 'assets/images/cars/toyotacamry.webp',
      'price': '22,500',
      'mileage': '18,000 mi',
      'color': 'Silver',
      'vin': '123456',
      'task': '2',
      'status': 'Available',
    },
    {
      'title': ' 2019 Mustang',
      'year': '2019',
      'imageUrl': 'assets/images/cars/fordmustang.jpg',
      'price': '32,500',
      'mileage': '25,000 mi',
      'color': 'Black',
      'vin': '123456',
      'task': '1',
      'status': 'Sold',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> filteredVehicles = allVehicles.where((
      vehicle,
    ) {
      if (selectedStatus == 'All Status') return true;
      return vehicle['status'] == selectedStatus;
    }).toList();
    //sort of filtered list by selectedSort
    filteredVehicles.sort((a, b) {
      // Newest First → Higher year first
      if (selectedSort == 'Newest First') {
        return b['year']!.compareTo(a['year']!);

        //Oldest First → Lower year first
      } else if (selectedSort == 'Oldest First') {
        return a['year']!.compareTo(b['year']!);

        // Price High to Low → Higher price first
      } else if (selectedSort == 'Price High to Low') {
        final int priceA = int.parse(a['price']!.replaceAll(',', ''));
        final int priceB = int.parse(b['price']!.replaceAll(',', ''));
        return priceB.compareTo(priceA);

        //Price Low to High → Lower price first
      } else if (selectedSort == 'Price Low to High') {
        final int priceA = int.parse(a['price']!.replaceAll(',', ''));
        final int priceB = int.parse(b['price']!.replaceAll(',', ''));
        return priceA.compareTo(priceB);
      } else {
        return 0;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(showAddForm ? 'Add New Vehicle' : 'Inventory'),
      ),
      body: showAddForm
          ? AddVehicleForm(
              // onCancel: () {
              //   setState(() {
              //     showAddForm = false;
              //   });
              // },
            )
          : ListView(
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

                ...filteredVehicles.map((vehicle) {
                  return InventoryVehicleCard(
                    title: vehicle['title']!,
                    imageUrl: vehicle['imageUrl']!,
                    price: vehicle['price']!,
                    mileage: vehicle['mileage']!,
                    color: vehicle['color']!,
                    vin: vehicle['vin']!,
                    task: vehicle['task']!,
                    status: vehicle['status']!,
                  );
                }).toList(),

                // InventoryVehicleCard(
                //   title: '2021 Chevrolet Equinox',
                //   imageUrl: 'assets/images/cars/chevrolet_equinox.webp',
                //   price: '25,500',
                //   mileage: '18,000 mi',
                //   color: 'Red',
                //   vin: '123456',
                //   task: '2',
                //   status: 'In Maintaince',
                // ),
                // InventoryVehicleCard(
                //   title: '2021 Honda Civic',
                //   imageUrl: 'assets/images/cars/hondacivic.jpg',
                //   price: '21,000',
                //   mileage: '15,000 mi',
                //   color: 'Blue',
                //   vin: '123456',
                //   task: '1',
                //   status: 'Pending Sale',
                // ),
                // InventoryVehicleCard(
                //   title: '2020 Toyota Camry',
                //   imageUrl: 'assets/images/cars/toyotacamry.webp',
                //   price: '22,500',
                //   mileage: '18,000 mi',
                //   color: 'Silver',
                //   vin: '123456',
                //   task: '2',
                //   status: 'Available',
                // ),
                // InventoryVehicleCard(
                //   title: 'Mustang',
                //   imageUrl: 'assets/images/cars/fordmustang.jpg',
                //   price: '32,500',
                //   mileage: '25,000 mi',
                //   color: 'Black',
                //   vin: '123456',
                //   task: '1',
                //   status: 'Sold',
                // ),
              ],
            ),
    );
  }
}
