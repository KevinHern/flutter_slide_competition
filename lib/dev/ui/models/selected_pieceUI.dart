// Basic Imports
import 'package:flutter/material.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

class SelectedPieceManagerUI extends ChangeNotifier {
  late Piece _selectedPiece;

  SelectedPieceManagerUI() {
    this._selectedPiece = Piece(rotation: PieceRotation.UP);
  }

  void update() => notifyListeners();

  // setters
  set selectPiece(Piece piece) {
    this._selectedPiece = piece;
    this.update();
  }

  // getters
  Piece get selectedPiece => this._selectedPiece;
}
