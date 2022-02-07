import 'package:flutter/material.dart';

import '../utils/my_utils.dart';

class PuzzleButton extends StatelessWidget {
  final double scale, height, width;
  final String iconName;
  final Function onPressed;

  const PuzzleButton(
      {required this.scale,
      required this.height,
      required this.width,
      required this.iconName,
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
          shadowColor: Colors.lightGreen,
          onPrimary: Colors.green,
        ),
        onPressed: () => this.onPressed(),
      ),
    );
  }
}

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
              SizedBox(
                height: this.padding * this.scale,
              ),
              Container(
                child: Row(
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
                          height: height,
                          width: width,
                          iconName: 'left',
                          onPressed: () => {},
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
                          height: height,
                          width: width,
                          iconName: 'up',
                          onPressed: () => {},
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
                          height: height,
                          width: width,
                          iconName: 'down',
                          onPressed: () => {},
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
                          height: height,
                          width: width,
                          iconName: 'right',
                          onPressed: () => {},
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
