import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/dpad.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/puzzle_button.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/rotation.dart';

import '../utils/my_utils.dart';

class BoardTestScreen extends StatelessWidget {
  final double scale;
  final double height = 40, width = 40;
  final double padding = 5;
  const BoardTestScreen({required this.scale, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MyUtils.setScreenPadding(context: context),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.lightBlue,
                height: 400,
                width: 400,
              ),
              const SizedBox(
                height: 50,
              ),
              DPad(
                scale: scale,
                isActive: false,
                upPress: () => {},
                rightPress: () => {},
                downPress: () => {},
                leftPress: () => {},
              ),
              const SizedBox(
                height: 50,
              ),
              RotationButtons(
                scale: scale,
                isActive: true,
                rotateLeft: () => {},
                rotateRight: () => {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
