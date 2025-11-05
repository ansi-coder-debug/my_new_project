import 'package:flutter/material.dart';
import 'package:flutter_query/flutter_query.dart';
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

  // only keeping auth setup
  final container = ProviderContainer();
  await container.read(authNotifierProvider.notifier).loadUserFromHive();

  runApp(
  QueryScope( // ✅ Adds global caching & query client
    child: UncontrolledProviderScope(
      container: container,
      child:  MyApp(),
    ),
  ),
);

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
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.white,
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          // foregroundColor: Colors.white
        ),
        primaryColor: Colors.white,

        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.blue),
          bodyLarge: TextStyle(color: Colors.lightGreenAccent),
        ),
      ),

      // Show login if user is not logged in
      home: authState.user == null ? LoginScreen() : ScreenMainPage(),
    );
  }
}
