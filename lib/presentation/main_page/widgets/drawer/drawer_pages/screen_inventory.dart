import 'package:flutter/material.dart';
import 'package:my_new_project/presentation/main_page/widgets/inventory_vehicle_card.dart';

//  Text('Inventory'),
class ScreenInventory extends StatelessWidget {
  const ScreenInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
          InventoryVehicleCard(
            title: '2021 Chevrolet Equinox',
            imageUrl: 'assets/images/cars/chevrolet_equinox.webp',
            price: '25,500',
            mileage: '18,000 mi',
            color: 'Red',
            vin: '123456',
          ),
          InventoryVehicleCard(
            title: '2021 Chevrolet Equinox',
            imageUrl: 'assets/images/cars/chevrolet_equinox.webp',
            price: '25,500',
            mileage: '18,000 mi',
            color: 'Red',
            vin: '123456',
          ),
        ],
      ),
    );
  }
}
