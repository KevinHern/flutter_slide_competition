import 'piece.dart';
import 'dart:developer';

enum BoardDirection {UP, DOWN, LEFT, RIGHT}

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

  bool addPiece({required Piece piece, required int row, required int col}) {
    piece.x = col;
    piece.y = row;

    // LOS NIVELES SERÁN DISEÑADOS A MANO
    // VERIFICACIONES AL MÍNIMO
    switch(piece.shape) {
      case PieceShape.DOT: {
        // No le importa la rotación
        board[row][col] = piece;
      }
        break;
      case PieceShape.SQUARE: {
        // No le importa la rotación
        board[row][col] = piece;
        board[row+1][col] = piece;
        board[row][col+1] = piece;
        board[row+1][col+1] = piece;
      }
        break;
      case PieceShape.LINE: {
        // Dos rotaciones posibles
        if (piece.rotation == PieceRotation.UP || piece.rotation == PieceRotation.DOWN) {
          board[row][col] = piece;
          board[row][col+1] = piece;
        } else {
          board[row][col] = piece;
          board[row+1][col] = piece;
        }
      }
        break;
      case PieceShape.L:
        // Cuatro rotaciones posibles
        if (piece.rotation == PieceRotation.UP) {
          board[row][col] = piece;
          board[row+1][col] = piece;
          board[row+1][col+1] = piece;
        } else if (piece.rotation == PieceRotation.DOWN) {
          board[row][col] = piece;
          board[row][col+1] = piece;
          board[row+1][col+1] = piece;
        } else if (piece.rotation == PieceRotation.LEFT) {
          board[row][col+1] = piece;
          board[row+1][col] = piece;
          board[row+1][col+1] = piece;
        } else if (piece.rotation == PieceRotation.RIGHT) {
          board[row][col] = piece;
          board[row+1][col] = piece;
          board[row][col+1] = piece;
        }
        break;
    }

    // Futureproofing
    // En caso se necesitara realizar verificaciones
    return true;
  }

  void prettyPrint() {
    log("Board --------------------");
    for (var r = 0; r < BOARD_SIZE; r++) {
      String rowStr = "";
      for (var c = 0; c < BOARD_SIZE; c++) {
        String singleStr = "";
        if (board[r][c] is NullPiece) {
          singleStr = " ";
        } else {
          switch(board[r][c].shape) {
            case PieceShape.DOT:    { singleStr = "D"; } break;
            case PieceShape.SQUARE: { singleStr = "S"; } break;
            case PieceShape.LINE:   { singleStr = "I"; } break;
            case PieceShape.L:      { singleStr = "L"; } break;
          } // end switch
        } // end if
        rowStr = rowStr + " " + singleStr;
      } // end inner for
      log(rowStr);
    } // end outter for
  }
}