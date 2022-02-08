// Basic Imports
import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/puzzle_button.dart';

class RotationButtons extends StatelessWidget {
  final double scale;
  final double height = 40, width = 40;
  final double padding = 10;
  final Color color;
  final bool isActive;
  final Function rotateLeft, rotateRight;
  const RotationButtons(
      {required this.scale,
      required this.isActive,
      required this.rotateLeft,
      required this.rotateRight,
      this.color = Colors.transparent,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PuzzleButton(
          scale: scale,
          height: height,
          width: width,
          iconName: 'rotate_left',
          color: Colors.transparent,
          onPressed: (this.isActive) ? () => this.rotateLeft() : null,
        ),
        SizedBox(
          width: padding * scale,
        ),
        PuzzleButton(
          scale: scale,
          height: height,
          width: width,
          iconName: 'rotate_right',
          color: Colors.transparent,
          onPressed: (this.isActive) ? () => this.rotateRight() : null,
        ),
      ],
    );
  }
}
