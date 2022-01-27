// Basic Imports
import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/prototype/ui/utils/my_utils.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

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
          child: WelcomeBody(),
        ),
      ),
    );
  }
}

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.lightGreen,
          child: const Text('*Insert intro images*'),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () => Navigator.of(context).popAndPushNamed('/puzzle'),
            child: Text('Begin')),
      ],
    );
  }
}
