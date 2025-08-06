import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/employee.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';

import 'package:my_new_project/core/models/expense.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/core/models/sales.dart';
import 'package:my_new_project/core/models/user/user.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/presentation/login/login_screen.dart';
import 'package:my_new_project/presentation/main_page/widgets/screen_main_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_new_project/core/models/purchase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // 1. FIRST register ALL adapters
  Hive.registerAdapter(VehicleAdapter());
  Hive.registerAdapter(PartnershipAdapter());
  Hive.registerAdapter(EmployeeAdapter());
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(PurchaseAdapter());
  Hive.registerAdapter(SalesAdapter());
  Hive.registerAdapter(UserAdapter()); // 👈 ADD THIS


  // 2. THEN open boxes
  await Hive.openBox<Vehicle>('vehicles');
  await Hive.openBox<Employee>('employees');
  await Hive.openBox<Expense>('expenses');
  await Hive.openBox<Partnership>('partnerships');
  await Hive.openBox<Purchase>('purchases');
  await Hive.openBox<Sales>('sales');
  await Hive.openBox('authBox');

  // // 3. Clear boxes if needed (only for development)
  // await Hive.box<Vehicle>('vehicles').clear();
  // await Hive.box<Partnership>('partnerships').clear();
  // await Hive.box<Sales>('sales').clear();
  // await Hive.box<Purchase>('purchases').clear();

  // ⬇️ Create ProviderContainer and load user
  final container = ProviderContainer();
  await container.read(authNotifierProvider.notifier).loadUserFromHive();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

// vehicle_provider.dart
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vehicle App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
        primaryColor: Colors.white,

        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      // Show login if user is not logged in
      home: authState.user == null ? LoginScreen() : ScreenMainPage(),
    );
  }
}
