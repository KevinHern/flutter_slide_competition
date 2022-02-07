// Basic Imports
import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/ui/screens/board_test.dart';

// Screens
import 'package:flutter_slide_competition/prototype/ui/screens/puzzle_screen.dart';
import 'package:flutter_slide_competition/prototype/ui/screens/welcome_screen.dart';
import 'package:flutter_slide_competition/prototype/ui/screens/closing_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sliding Puzzle Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        //'/': (context) => const WelcomeScreen(),
        '/': (context) => const BoardTestScreen(
              scale: 2,
            ),
        '/puzzle': (context) => const PuzzleScreen(),
        '/end': (context) => const ClosingScreen(),
      },
    );
  }
}
