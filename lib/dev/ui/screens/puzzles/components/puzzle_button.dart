import 'package:flutter/material.dart';

class PuzzleButton extends StatelessWidget {
  final double scale, height, width;
  final String iconName;
  final Function? onPressed;
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
        child: Image.asset('icons/' + this.iconName + '.png'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          primary: Colors.transparent,
          shadowColor: this.color,
          onPrimary: this.color,
        ),
        onPressed: (this.onPressed == null) ? null : () => this.onPressed!(),
      ),
    );
  }
}
