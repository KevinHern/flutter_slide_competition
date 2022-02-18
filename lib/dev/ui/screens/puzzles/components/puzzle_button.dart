import 'package:flutter/material.dart';

class PuzzleButton extends StatelessWidget {
  final double scale, height, width;
  final String iconName;
  final Function? onPressed;
  final Color color, cardColor;
  final double borderRadius, elevation;
  final bool includeCard;

  const PuzzleButton(
      {required this.scale,
      required this.height,
      required this.width,
      required this.iconName,
      required this.color,
      required this.onPressed,
      this.borderRadius = 5.0,
      this.elevation = 10.0,
      this.includeCard = false,
      this.cardColor = Colors.white,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height * this.scale,
      width: this.width * this.scale,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(this.borderRadius),
        //color: Colors.black45,
      ),
      child: ElevatedButton(
        child: (this.includeCard)
            ? Card(
                child: Image.asset(
                  'icons/' + this.iconName + '.png',
                ),
                color: this.cardColor,
                elevation: this.elevation,
              )
            : Image.asset(
                'icons/' + this.iconName + '.png',
              ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          primary: Colors.transparent,
          shadowColor: this.color,
          onPrimary: this.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(this.borderRadius),
            side: const BorderSide(
              color: Colors.transparent,
              width: 2.0,
            ),
          ),
          elevation: this.elevation,
        ),
        onPressed: (this.onPressed == null) ? null : () => this.onPressed!(),
      ),
    );
  }
}

class IconPuzzleButton extends StatelessWidget {
  // Mandatory Parameters
  final String icon, text;
  final Function? onPressed;

  // Optional parameters
  static const iconSize = 60;
  final double scale, elevation, buttonRadius, innerPadding;
  final Color buttonColor, clickColor, shadowColor;
  const IconPuzzleButton(
      {required this.scale,
      required this.icon,
      required this.text,
      required this.onPressed,
      this.elevation = 10.0,
      this.innerPadding = 20.0,
      this.buttonRadius = 15.0,
      this.buttonColor = const Color(0xFFF3C98B),
      this.clickColor = const Color(0xFFfffcbc),
      this.shadowColor = const Color(0xFFbf985d),
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Column(
        children: [
          SizedBox.square(
            dimension: iconSize * this.scale,
            child: Image.asset('icons/' + this.icon + '.png'),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            this.text,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        elevation: this.elevation,
        padding: EdgeInsets.all(this.innerPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(this.buttonRadius),
        ),
        primary: this.buttonColor,
        onPrimary: this.clickColor,
        shadowColor: this.shadowColor,
      ),
      onPressed: (this.onPressed == null) ? null : () => this.onPressed!(),
    );
  }
}
