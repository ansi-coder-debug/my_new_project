import 'package:flutter/material.dart';
import 'package:my_new_project/presentation/main_page/widgets/screen_main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
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
    home: ScreenMainPage(),
    );
  }
}
