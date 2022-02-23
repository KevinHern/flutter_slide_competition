import 'dart:math';

import 'package:flutter/material.dart';

import '../../../dev/data/models/level_manager.dart';

class MyUtils {
  static EdgeInsetsGeometry setScreenPadding({required BuildContext context}) {
    final double width = MediaQuery.of(context).size.width;

    //log("width: $width");

    if (width >= 1200) {
      return EdgeInsets.symmetric(
          horizontal: width * 0.05, vertical: width * 0.01);
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

  static String fetchRandomImage({required PuzzleType puzzleType}) {
    const soundImages = [
      'flute',
      'harp',
      'ocarina',
      'piano',
      'violonchelo',
      'guitar'
    ];
    const spatialImages = [
      'pattern1',
      'pattern2',
      'sculpture2',
      'statue',
      'pattern3',
      'pattern4'
    ];
    switch (puzzleType) {
      case PuzzleType.SOUND:
        return soundImages[Random().nextInt(soundImages.length)];
      case PuzzleType.SPATIAL:
        return spatialImages[Random().nextInt(spatialImages.length)];
      default:
        throw Exception('Fetch Random Image: Unknown Puzzle Type detected');
    }
  }

  static Future showMessage(
      {required BuildContext context,
      required String title,
      required String message,
      required Function onPressed}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                onPressed();
                Navigator.of(context).pop();
              },
              child: Text(
                'Ok',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        );
      },
    );
  }
}
