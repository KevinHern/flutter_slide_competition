import 'piece.dart';

class SelectedPieceManager {
  final List<Piece> puzzlePieces;
  int selectedIndex = -1;

  SelectedPieceManager({this.puzzlePieces = const []});

  void addPiece({required Piece puzzlePiece}) {
    this.puzzlePieces.add(puzzlePiece);
  }

  // Obtiene *alguna* pieza según el index dado
  Piece getPiece({required int index}) => this.puzzlePieces[index];
  // Obtiene *la pieza* seleccionada
  Piece getSelectedPiece() => this.puzzlePieces[selectedIndex];
  // Deselecciona *la pieza* seleccionada
  int unselectSelectedPiece () {
    this.puzzlePieces[selectedIndex].isSelected = false;
    int old = selectedIndex;
    selectedIndex = -1;
    return old;
  }

  // Busca *alguna* pieza
  int getIndexOfPiece({required Piece piece}) => this.puzzlePieces.indexOf(piece);
  // Busca *la pieza* seleccionada, actualizando el indice en el proceso
  int updateSelectedPiece({required Piece piece}) {
    int i = this.puzzlePieces.indexOf(piece);
    this.selectedIndex = i;
    this.puzzlePieces[selectedIndex].isSelected = true;
    return i;
  }
}