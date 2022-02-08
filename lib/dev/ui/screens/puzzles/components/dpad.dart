import 'package:flutter/material.dart';

class PuzzleButton extends StatelessWidget {
  final double scale, height, width;
  final String iconName;
  final Function onPressed;
  final Color color;

  const PuzzleButton(
      {required this.scale,
      required this.height,
      required this.width,
      required this.iconName,
      required this.color,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height * this.scale,
      width: this.width * this.scale,
      padding: const EdgeInsets.all(0),
      child: ElevatedButton(
        child: Image.asset('icons/' + this.iconName + '_arrow.png'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          primary: Colors.transparent,
          shadowColor: this.color,
          onPrimary: this.color,
        ),
        onPressed: () => this.onPressed(),
      ),
    );
  }
}

class DPad extends StatelessWidget {
  final double scale;
  final double height = 40, width = 40;
  final double padding = 5;
  final Color color;
  final Function upPress, rightPress, downPress, leftPress;
  const DPad(
      {required this.scale,
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
              iconName: 'left',
              color: this.color,
              onPressed: () => this.leftPress(),
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
              iconName: 'up',
              color: this.color,
              onPressed: () => this.upPress(),
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
              iconName: 'down',
              color: this.color,
              onPressed: () => this.downPress(),
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
              iconName: 'right',
              color: this.color,
              onPressed: () => this.rightPress(),
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
