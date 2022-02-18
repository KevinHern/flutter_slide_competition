import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/dpad.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/rotation.dart';

class UITestScreen extends StatelessWidget {
  const UITestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: Row(
          children: [
            DPad(
              scale: 1.5,
              elevation: 10.0,
              isActive: true,
              upPress: () {},
              rightPress: () {},
              downPress: () {},
              leftPress: () {},
            ),
            RotationButtons(
              scale: 2.0,
              isActive: true,
              color: const Color(0xFF4E7F7F),
              rotateLeft: () {},
              rotateRight: () {},
            ),
          ],
        ),
      ),
    );
  }
}
