// constants/vehicle_makes.dart

class VehicleMakes {
  // List of bike manufacturers (makes)
  static const List<String> bikeMakes = [
    'Hero',
    'Honda',
    'Bajaj',
    'TVS',
    'Royal Enfield',
    'Suzuki',
    'Yamaha',
    'Kawasaki',
    'KTM',
    'BMW',
    'Ducati',
    'Harley-Davidson',
    'Triumph',
    'Mahindra',
    'Jawa',
    'Benelli',
    'Aprilia',
    'Vespa',
    'Indian',
    'Husqvarna',
    'Moto Guzzi',
    'MV Agusta',
    'UM Motorcycles',
    'Hyosung',
    'CFMoto',
    'Okinawa',
    'Ather',
    'Revolt',
    'Ola Electric',
  ];

  // List of car manufacturers (makes) in India
  static const List<String> carMakes = [
    'Maruti Suzuki',
    'Hyundai',
    'Tata',
    'Mahindra',
    'Kia',
    'Toyota',
    'Honda',
    'MG',
    'Skoda',
    'Volkswagen',
    'Renault',
    'Nissan',
    'Ford',
    'Citroen',
    'Jeep',
    'BMW',
    'Mercedes-Benz',
    'Audi',
    'Land Rover',
    'Volvo',
    'Jaguar',
    'Porsche',
    'Lamborghini',
    'Ferrari',
    'Aston Martin',
    'Rolls-Royce',
    'Bentley',
    'BYD',
    'Tesla',
  ];

  // List of truck manufacturers
  static const List<String> truckMakes = [
    'Tata',
    'Ashok Leyland',
    'Mahindra',
    'Eicher',
    'BharatBenz',
    'Volvo',
    'Scania',
    'MAN',
  ];

  // List for "Other" vehicle type
  static const List<String> otherMakes = [
    'Custom',
    'Imported',
    'Other',
  ];

  // Get the appropriate list based on vehicle type
  static List<String> getMakesForVehicleType(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'bike':
        return bikeMakes;
      case 'car':
        return carMakes;
      case 'truck':
        return truckMakes;
      case 'other':
        return otherMakes;
      default:
        return bikeMakes; // Default to bike makes
    }
  }
}