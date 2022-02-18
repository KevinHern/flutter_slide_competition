// Basic Imports
import 'package:flutter/material.dart';

class ToggleRotation extends ChangeNotifier {
  late bool _canRotate;

  ToggleRotation({required bool canRotate}) {
    this._canRotate = canRotate;
  }

  // Setters
  set canRotate(bool rotate) => this._canRotate = rotate;

  // Getters
  bool get canRotate => this._canRotate;

  void update() => notifyListeners();
}

class UniversalPuzzleToggleManager extends ChangeNotifier {
  bool _showBag, _showWinButton;

  UniversalPuzzleToggleManager()
      : this._showBag = true,
        this._showWinButton = false;

  void update() => notifyListeners();

  // Setters
  set showBag(bool show) {
    this._showBag = show;
    this.update();
  }

  set showWinButton(bool show) {
    this._showWinButton = show;
    this.update();
  }

  // Getters
  bool get canShowBag => this._showBag;
  bool get canShowWinButtonActive => this._showWinButton;
}
