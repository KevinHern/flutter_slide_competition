// Basic Imports
import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/puzzle_button.dart';

class DPad extends StatelessWidget {
  final double scale;
  final double height = 40, width = 40;
  final double padding = 5;
  final Color color;
  final bool isActive;
  final Function upPress, rightPress, downPress, leftPress;
  const DPad(
      {required this.scale,
      required this.isActive,
      required this.upPress,
      required this.rightPress,
      required this.downPress,
      required this.leftPress,
      this.color = Colors.green,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            SizedBox(
              height: this.height * this.scale,
              width: this.width * this.scale,
            ),
            SizedBox(
              height: this.padding * this.scale,
            ),
            PuzzleButton(
              scale: this.scale,
              height: this.height,
              width: this.width,
              iconName: 'left_arrow',
              color: this.color,
              onPressed: (this.isActive) ? () => this.leftPress() : null,
            ),
            SizedBox(
              height: this.padding * this.scale,
            ),
            SizedBox(
              height: this.height * this.scale,
              width: this.width * this.scale,
            ),
          ],
        ),
        SizedBox(
          width: this.padding * this.scale,
        ),
        Column(
          children: [
            PuzzleButton(
              scale: this.scale,
              height: this.height,
              width: this.width,
              iconName: 'up_arrow',
              color: this.color,
              onPressed: (this.isActive) ? () => this.upPress() : null,
            ),
            SizedBox(
              height: this.padding * this.scale,
            ),
            SizedBox(
              height: this.height * this.scale,
              width: this.width * this.scale,
            ),
            SizedBox(
              height: this.padding * this.scale,
            ),
            PuzzleButton(
              scale: this.scale,
              height: this.height,
              width: this.width,
              iconName: 'down_arrow',
              color: this.color,
              onPressed: (this.isActive) ? () => this.downPress() : null,
            ),
          ],
        ),
        SizedBox(
          width: this.padding * this.scale,
        ),
        Column(
          children: [
            SizedBox(
              height: this.height * this.scale,
              width: this.width * this.scale,
            ),
            SizedBox(
              height: this.padding * this.scale,
            ),
            PuzzleButton(
              scale: this.scale,
              height: this.height,
              width: this.width,
              iconName: 'right_arrow',
              color: this.color,
              onPressed: (this.isActive) ? () => this.rightPress() : null,
            ),
            SizedBox(
              height: this.padding * this.scale,
            ),
            SizedBox(
              height: this.height * this.scale,
              width: this.width * this.scale,
            ),
          ],
        ),
      ],
    );
  }
}
