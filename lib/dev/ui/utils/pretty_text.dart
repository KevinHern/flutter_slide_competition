import 'package:flutter/material.dart';

class PrettyText extends StatelessWidget {
  final String text;
  final double size;
  final double thickness;
  final Color background;

  PrettyText(this.text, {this.size = 20, this.thickness = 3, this.background = Colors.black54});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: size*4, vertical: size),
      decoration: BoxDecoration(
        color: background,
      ),
      child: Stack(
        children: [
          // Orilla negra
          Text(
            text,
            style: TextStyle(
              fontSize: size,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = thickness
                ..color = Colors.black,
            ),
          ),

          // Relleno blanco
          Text(
            text,
            style: TextStyle(
              fontSize: size,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}