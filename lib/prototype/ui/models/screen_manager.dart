import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/prototype/data/models/puzzle.dart';

enum ScreenType {
  SELECT_PUZZLE,
  FORCED_PUZZLE,
  AUDITIVE_PUZZLE,
  SPATIAL_PUZZLE,
}

class NavigationManager extends ChangeNotifier {
  late ScreenType _currentScreen;
  late Puzzle _puzzle;

  NavigationManager({required ScreenType currentScreen}) {
    this._currentScreen = currentScreen;
  }

  // Setters
  set setPuzzle(Puzzle puzzle) => this._puzzle = puzzle;
  set setCurrentScreen(ScreenType screenType) =>
      this._currentScreen = screenType;

  // Getters
  Puzzle get getPuzzle => this._puzzle;
  ScreenType get getCurrentScreen => this._currentScreen;

  // Update UI
  void update() => notifyListeners();
}
