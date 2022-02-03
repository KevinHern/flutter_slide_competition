// Basic Imports
import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/prototype/ui/utils/my_utils.dart';
import 'package:flutter_slide_competition/prototype/ui/utils/pretty_text.dart';

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
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/happy_ghost.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
          children: [
            SizedBox(
              height: MyUtils.getTopSpacerSize(context: context) * 2,
            ),
            PrettyText("I didn't remember that humans were so much fun! Come to explore again whenever you want and bring your friends too!",
              size: 32,
              background: Colors.black26,
            ),
            SizedBox(
              height: MyUtils.getTopSpacerSize(context: context) * 7,
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).popAndPushNamed('/'),
              child: const Text(
                  "PLAY AGAIN",
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
