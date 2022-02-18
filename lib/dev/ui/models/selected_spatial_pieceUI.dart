// Basic Imports
import 'package:flutter/material.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

class SpatialPieceManagerUI extends ChangeNotifier {
  late Piece _selectedPiece;

  SpatialPieceManagerUI() {
    this._selectedPiece = Piece.createNullPiece();
  }

  void update() => notifyListeners();

  // setters
  set selectedPiece(Piece piece) {
    this._selectedPiece = piece;
    this.update();
  }

  // getters
  Piece get selectedPiece => this._selectedPiece;
}
