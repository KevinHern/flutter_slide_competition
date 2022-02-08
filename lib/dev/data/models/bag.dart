import 'piece.dart';

class Bag {
  final List<Piece> puzzlePieces;

  Bag({this.puzzlePieces = const []});

  void addPiece({required Piece puzzlePiece}) {
    this.puzzlePieces.add(puzzlePiece);
  }

  Piece getPiece({required int index}) => this.puzzlePieces[index];

  Piece removePiece({required int index}) => this.puzzlePieces.removeAt(index);
  bool erasePiece({required Piece puzzlePiece}) =>
      this.puzzlePieces.remove(puzzlePiece);

  // Getters
  int get length => this.puzzlePieces.length;
  List<Piece> get pieces => this.puzzlePieces;
}
