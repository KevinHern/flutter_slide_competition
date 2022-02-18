// Basic Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/puzzle_button.dart';

class DPad extends StatelessWidget {
  final double scale, elevation;
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
      this.elevation = 10.0,
      this.color = const Color(0xFF2F7AC0),
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
              elevation: this.elevation,
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
              elevation: this.elevation,
              iconName: 'up_arrow',
              color: this.color,
              onPressed: (this.isActive) ? () => this.upPress() : null,
            ),
            SizedBox(
              height: this.padding * this.scale,
            ),
            Material(
              elevation: this.elevation,
              color: Colors.transparent,
              shadowColor: this.color,
              shape: const CircleBorder(),
              child: SizedBox(
                height: this.height * this.scale,
                width: this.width * this.scale,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF9CCCFC),
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1.5,
                      color: this.color.withOpacity(0.75),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: this.color,
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: this.padding * this.scale,
            ),
            PuzzleButton(
              scale: this.scale,
              height: this.height,
              width: this.width,
              elevation: this.elevation,
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
              elevation: this.elevation,
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
