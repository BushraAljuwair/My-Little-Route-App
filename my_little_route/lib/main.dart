import 'package:flutter/material.dart';
import 'package:my_little_route/features/auth/signup_screen.dart';
import 'package:my_little_route/style/theme/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     // darkTheme: ,
      theme: CustomTheme.lightTheme,
      home:const SignupScreen()
    );
  }
}
