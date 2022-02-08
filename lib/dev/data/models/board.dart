import 'piece.dart';

class Board {
  static const int BOARD_SIZE = 8;

  late List<List<Piece>> board;

  // Board de 8x8 casillas
  // Se usa la clase dummy NullPiece para rellenar, por el null safety
  Board() {
     this.board = List.generate(
         BOARD_SIZE,
             (_) => List.generate(
                 BOARD_SIZE,
                     (__) => NullPiece(),
                 growable: false),
         growable: false
     );
  }

  void addPiece({required Piece piece, required int row, required int col}) {
    piece.x = col;
    piece.y = row;

    // todo: considerar todas las formas y rotaciones
    board[row][col] = piece;
  }
}