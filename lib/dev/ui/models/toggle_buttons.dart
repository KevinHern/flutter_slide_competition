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
