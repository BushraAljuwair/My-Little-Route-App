// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:my_little_route/style/style_color.dart';

class StyleText {
 
  static String _getFontFamily(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    return langCode == 'en' ? 'SFCompactRounded' : 'SFArabicRounded';
  }

  static Color _getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? StyleColor.white
        : StyleColor.black;
  }

  static TextStyle bold24(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: _getTextColor(context),
    );
  }
   static TextStyle bold20(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: _getTextColor(context),
    );
  }
    static TextStyle boldBlue20(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color:StyleColor.lapislazuli,
    );
  }

  static TextStyle bold16(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: _getTextColor(context),
    );
  }

  static TextStyle bold16black(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: StyleColor.black,
    );
  }

  static TextStyle bold12(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: _getTextColor(context),
    );
  }

  static TextStyle regular16(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: _getTextColor(context),
    );
  }

  static TextStyle regular12(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: _getTextColor(context),
    );
  }

  static TextStyle regular16Grey(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: StyleColor.gray,
    );
  }

  static TextStyle buttonText16(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: StyleColor.black,
    );
  }
  
  static TextStyle buttonText16Blue(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: StyleColor.blue,
    );
  }

  static TextStyle buttonText12(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: StyleColor.white,
    );
  }

  static TextStyle greenButtonText12(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: StyleColor.black,
    );
  }

  static TextStyle regular16Green(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: StyleColor.green,
    );
  }

  static TextStyle regular16Error(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: StyleColor.red,
    );
  }
}
