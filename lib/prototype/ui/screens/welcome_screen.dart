// Basic Imports
import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/prototype/ui/utils/my_utils.dart';
import 'package:flutter_slide_competition/prototype/ui/utils/pretty_text.dart';

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
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/mansion.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: MyUtils.getTopSpacerSize(context: context) * 2,
          ),
          PrettyText("I heard some rumors about something strange happening in this abandoned mansion, so I decided to investigate...",
            size: 32,
            background: Colors.black45,
          ),
          SizedBox(
            height: MyUtils.getTopSpacerSize(context: context) * 7,
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).popAndPushNamed('/puzzle'),
            child: const Text(
                "ENTER THE MANSION",
                style: TextStyle(
                  fontSize: 24,
                )
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.indigo,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          )
        ]
      ),
    );
  }
}
