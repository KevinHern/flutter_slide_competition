import 'package:flutter/material.dart';
import 'dart:developer';

class MyUtils {
  static EdgeInsetsGeometry setScreenPadding({required BuildContext context}) {
    final double width = MediaQuery.of(context).size.width;

    //log("width: $width");

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

  static double getTopSpacerSize({required BuildContext context}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    //log("height: $height");

    if (width <= 600) {
      return 20;
    } else if (width <= 1000) {
      return 40;
    }

    if (height >= 900) {
      return 60;
    } else if (height >= 700) {
      return 40;
    } else {
      return 20;
    }
  }

  static double getSwitchBodyHeight({required BuildContext context}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    if ((width * height) <= (650 * 650)) {
      return height * 0.45;
    } else if ((width * height) <= (850 * 850)) {
      return height * 0.50;
    } else if ((width * height) <= (1050 * 1050)) {
      return height * 0.55;
    }

    return height * 0.60;
  }

  static double getPrettyTextFontSize({required BuildContext context}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    if ((width * height) <= (650 * 650)) {
      return 14;
    } else if ((width * height) <= (850 * 850)) {
      return 16;
    } else if ((width * height) <= (1050 * 1050)) {
      return 18;
    }

    return 20;
  }
}
