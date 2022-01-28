import 'package:flutter/material.dart';

class MyUtils {
  static EdgeInsetsGeometry setScreenPadding({required BuildContext context}) {
    final double width = MediaQuery.of(context).size.width;

    if (width >= 1200) {
      return EdgeInsets.symmetric(
          horizontal: width * 0.2, vertical: width * 0.01);
    } else if (width >= 992) {
      return EdgeInsets.symmetric(
          horizontal: width * 0.1, vertical: width * 0.01);
    } else if (width >= 768) {
      return EdgeInsets.symmetric(
          horizontal: width * 0.075, vertical: width * 0.05);
    } else {
      return EdgeInsets.symmetric(
          horizontal: width * 0.05, vertical: width * 0.05);
    }
  }

  static double getContainerWidth({required BuildContext context}) {
    final double width = MediaQuery.of(context).size.width;

    if (width >= 1200) {
      return width * 0.6;
    } else if (width >= 992) {
      return width * 0.8;
    } else if (width >= 768) {
      return width * 0.85;
    } else {
      return width * 0.9;
    }
  }
}
