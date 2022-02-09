// Basic Imports
import 'package:flutter/material.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/board.dart';

class BoardUI extends ChangeNotifier {
  late final Board _board;

  BoardUI({required Board board}) {
    this._board = board;
  }

  // getters
  Board get board => this._board;

  void update() => notifyListeners();
}