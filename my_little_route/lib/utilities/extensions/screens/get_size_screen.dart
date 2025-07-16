import 'package:flutter/material.dart';

/// Extension on BuildContext to quickly access screen dimensions.
extension Screen on BuildContext {
  double getWidth() {
    return MediaQuery.sizeOf(this).width;
  }

  double getHeight() {
    return MediaQuery.sizeOf(this).height;
  }
}
