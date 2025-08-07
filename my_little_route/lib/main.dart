import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_little_route/features/auth/login_screen.dart';
import 'package:my_little_route/features/auth/signup_screen.dart';
import 'package:my_little_route/features/driver/nav/driver_nav_screen.dart';
import 'package:my_little_route/features/loading/loading_screen.dart';
import 'package:my_little_route/style/theme/theme.dart';
import 'package:my_little_route/tray.dart';
import 'package:my_little_route/utilities/setup.dart';

void main() async {
  await setUp();
  // runApp(const MainApp());

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('ar', 'AR')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: Locale('en', 'US'),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // darkTheme: ,z
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: CustomTheme.lightTheme,
      home:const LoadingScreen(),
      // home: const DriverNavScreen(),
    );
  }
}
