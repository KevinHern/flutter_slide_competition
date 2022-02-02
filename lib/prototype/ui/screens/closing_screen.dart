// Basic Imports
import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/prototype/ui/utils/my_utils.dart';

class ClosingScreen extends StatelessWidget {
  const ClosingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black38,
        title: const Text(
          'The Cursed Journal Entry',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFd4d4d4),
      body: Padding(
        padding: MyUtils.setScreenPadding(context: context),
        child: const Center(
          child: ClosingBody(),
        ),
      ),
    );
  }
}

class ClosingBody extends StatelessWidget {
  const ClosingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 400,
          color: Colors.lightGreen,
            child: Image.asset(
                'assets/happy_ghost.jpg'
            )
        ),
        const Text("I didn't even remember that humans were so much fun! Please come again soon and bring your friends to explore!",
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () => Navigator.of(context).popAndPushNamed('/'),
            child: Text('Restart!')),
      ],
    );
  }
}
