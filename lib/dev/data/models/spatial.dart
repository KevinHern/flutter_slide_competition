import 'package:flutter_slide_competition/dev/data/models/piece.dart';

class SpatialManager {
  static const int BOARD_SIZE = 6;

  late List<Piece> targetPuzzlePieces;
  late List<List<Piece>> targetBoard;

  late List<Piece> userPuzzlePieces;
  late List<List<Piece>> userBoard;

  static Piece nullPiece = Piece.createNullPiece();

  SpatialManager() {
    this.targetBoard = List.generate(
        BOARD_SIZE,
            (_) => List.generate(
            BOARD_SIZE,
                (__) => nullPiece,
            growable: false),
        growable: false
    );
    targetPuzzlePieces = [];

    this.userBoard = List.generate(
        BOARD_SIZE,
            (_) => List.generate(
            BOARD_SIZE,
                (__) => nullPiece,
            growable: false),
        growable: false
    );
    userPuzzlePieces = [];
  }

  bool addPieceToTargetBoard({required Piece piece, required int row, required int col}) {
    piece.x = col;
    piece.y = row;

    targetPuzzlePieces.add(piece);

    // LOS NIVELES SERÁN DISEÑADOS A MANO
    // VERIFICACIONES AL MÍNIMO
    switch(piece.shape) {
      case PieceShape.DOT: {
        // No le importa la rotación
        targetBoard[row][col] = piece;
      }
      break;
      case PieceShape.SQUARE: {
        // No le importa la rotación
        targetBoard[row][col] = piece;
        targetBoard[row+1][col] = piece;
        targetBoard[row][col+1] = piece;
        targetBoard[row+1][col+1] = piece;
      }
      break;
      case PieceShape.LINE: {
        // Dos rotaciones posibles
        if (piece.rotation == PieceRotation.UP || piece.rotation == PieceRotation.DOWN) {
          targetBoard[row][col] = piece;
          targetBoard[row][col+1] = piece;
        } else {
          targetBoard[row][col] = piece;
          targetBoard[row+1][col] = piece;
        }
      }
      break;
      case PieceShape.L:
      // Cuatro rotaciones posibles
        if (piece.rotation == PieceRotation.UP) {
          targetBoard[row][col] = piece;
          targetBoard[row+1][col] = piece;
          targetBoard[row+1][col+1] = piece;
        } else if (piece.rotation == PieceRotation.DOWN) {
          targetBoard[row][col] = piece;
          targetBoard[row][col+1] = piece;
          targetBoard[row+1][col+1] = piece;
        } else if (piece.rotation == PieceRotation.LEFT) {
          targetBoard[row][col+1] = piece;
          targetBoard[row+1][col] = piece;
          targetBoard[row+1][col+1] = piece;
        } else if (piece.rotation == PieceRotation.RIGHT) {
          targetBoard[row][col] = piece;
          targetBoard[row+1][col] = piece;
          targetBoard[row][col+1] = piece;
        }
        break;
    }

    // Futureproofing
    // En caso se necesitara realizar verificaciones
    return true;
  }
}
