import 'package:flutter/material.dart';
import 'package:my_little_route/style/style_color.dart';

class CustomTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: StyleColor.lapislazuli,
      onPrimary: StyleColor.blue,
      secondary: StyleColor.mintCream,
      onSecondary: StyleColor.black,
      error: StyleColor.red,
      onError: StyleColor.red,
      surface: StyleColor.white,
      onSurface: StyleColor.green,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: StyleColor.blue,
      titleTextStyle: TextStyle(fontSize: 30, color: StyleColor.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(StyleColor.white),
        backgroundColor: WidgetStateProperty.all(StyleColor.blue),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        minimumSize: WidgetStateProperty.all(const Size.fromHeight(60)),
      ),
    ),
  );
}