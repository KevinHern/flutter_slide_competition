// Basic Imports
import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/unit_testing/bag_test.dart';
import 'package:flutter_slide_competition/unit_testing/board_test.dart';

// Screens
import 'package:flutter_slide_competition/dev/ui/screens/puzzle_screen.dart';
import 'package:flutter_slide_competition/dev/ui/screens/welcome_screen.dart';
import 'package:flutter_slide_competition/dev/ui/screens/closing_screen.dart';
import 'package:flutter_slide_competition/unit_testing/complete_test.dart';
import 'package:flutter_slide_competition/unit_testing/spatial_test.dart';
import 'package:flutter_slide_competition/unit_testing/ui_test.dart';
import 'package:flutter_slide_competition/unit_testing/unit_test_menu.dart';

// UI stuff
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

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
        textTheme: TextTheme(
          headline1: GoogleFonts.hennyPenny(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
          headline2: GoogleFonts.hennyPenny(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          headline3: GoogleFonts.hennyPenny(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          subtitle1: GoogleFonts.lora(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          subtitle2: GoogleFonts.lora(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          bodyText1: GoogleFonts.droidSerif(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        //'/': (context) => const WelcomeScreen(),
        '/': (context) => const UnitTestMenu(),
        '/bag_test': (context) => BagTestScreen(),
        '/board_test': (context) => BoardTestScreen(scale: 2),
        '/ui_test': (context) => const UITestScreen(),
        '/complete_test': (context) => CompleteTestScreen(scale: 2),
        '/spatial_test': (context) => SpatialTestScreen(scale: 2),
        '/welcome': (context) => const WelcomeScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/puzzle':
            return PageTransition(
              child: const PuzzleScreen(),
              type: PageTransitionType.fade,
              settings: settings,
              reverseDuration: const Duration(seconds: 3),
            );
          case '/end':
            return PageTransition(
              child: const ClosingScreen(),
              type: PageTransitionType.rightToLeftWithFade,
              settings: settings,
              reverseDuration: const Duration(seconds: 3),
            );
        }
      },
    );
  }
}
