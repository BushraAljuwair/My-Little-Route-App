import 'package:flutter/material.dart';
import 'package:my_little_route/features/auth/login_screen.dart';
import 'package:my_little_route/features/auth/signup_screen.dart';
import 'package:my_little_route/features/loading/loading_screen.dart';
import 'package:my_little_route/style/theme/theme.dart';
import 'package:my_little_route/utilities/setup.dart';

void main()async {
   await setUp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     // darkTheme: ,
      theme: CustomTheme.lightTheme,
      home:const LoadingScreen()
    );
  }
}
