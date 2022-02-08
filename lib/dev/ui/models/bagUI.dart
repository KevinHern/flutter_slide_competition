// Basic Imports
import 'package:flutter/material.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/bag.dart';

class BagUI extends ChangeNotifier {
  late final Bag _bag;

  BagUI({required Bag bag}) {
    this._bag = bag;
  }

  void update() => notifyListeners();
}
