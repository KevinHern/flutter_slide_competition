// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

class SelectedPiece {
  late final List<Piece> _pieces;
  late int _selectedPieceIndex;
  SelectedPiece({required List<Piece> pieces}) {
    this._pieces = pieces;
    this._selectedPieceIndex = -1;
  }

  // getters
  List<Piece> get pieces => this._pieces;
  int get selectedPieceIndex => this._selectedPieceIndex;

  // setters
  set selectedPiece(int index) => this._selectedPieceIndex = index;
}
