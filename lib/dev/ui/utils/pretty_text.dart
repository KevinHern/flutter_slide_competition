import 'package:flutter/material.dart';

class PrettyText extends StatelessWidget {
  final String text;
  final double size, verticalPadding, horizontalPadding;
  final double thickness;
  final Color background;
  final String? fontFamily;

  const PrettyText(
    this.text, {
    this.size = 20,
    this.thickness = 3,
    this.background = Colors.black54,
    this.fontFamily,
    this.verticalPadding = 20.0,
    this.horizontalPadding = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: this.horizontalPadding, vertical: this.verticalPadding),
      decoration: BoxDecoration(
        color: background,
      ),
      child: Center(
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
                fontFamily: (this.fontFamily == null)
                    ? Theme.of(context).textTheme.bodyText1!.fontFamily
                    : this.fontFamily,
              ),
            ),

            // Relleno blanco
            Text(
              text,
              style: TextStyle(
                fontSize: size,
                color: Colors.white,
                fontFamily: (this.fontFamily == null)
                    ? Theme.of(context).textTheme.bodyText1!.fontFamily
                    : this.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AwesomeText extends StatelessWidget {
  final String text;
  final double size, verticalPadding, horizontalPadding;
  final double thickness;
  final Color background;
  final String? fontFamily;

  const AwesomeText(this.text,
      {this.size = 20,
      this.thickness = 3,
      this.background = Colors.black54,
      this.fontFamily,
      this.verticalPadding = 20.0,
      this.horizontalPadding = 20.0,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            fontFamily: (this.fontFamily == null)
                ? Theme.of(context).textTheme.bodyText1!.fontFamily
                : this.fontFamily,
          ),
        ),

        // Relleno blanco
        Text(
          text,
          style: TextStyle(
            fontSize: size,
            color: Colors.white,
            fontFamily: (this.fontFamily == null)
                ? Theme.of(context).textTheme.bodyText1!.fontFamily
                : this.fontFamily,
          ),
        ),
      ],
    );
  }
}
