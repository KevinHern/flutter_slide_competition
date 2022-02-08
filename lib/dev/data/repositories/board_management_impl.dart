// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/board.dart';

// Contracts
import 'package:flutter_slide_competition/dev/domain/repositories/board_management_contract.dart';

class BoardManagementRepositoryImpl implements BoardManagementRepository {
  late final Board _board;

  BoardManagementRepositoryImpl({required Board board}) {
    this._board = board;
  }

  @override
  bool checkCollision({required BoardDirection direction, required Piece piece}) {
    // posicion actual de pieza
    int row = piece.y;
    int col = piece.x;

    switch (piece.shape) {
      case PieceShape.DOT: {
        switch (direction) {
          case BoardDirection.UP: {
            return (row > 0 && _board.board[row - 1][col] is NullPiece);
          }
          case BoardDirection.DOWN: {
            return (row < 7 && _board.board[row + 1][col] is NullPiece);
          }
          case BoardDirection.LEFT: {
            return (col > 0 && _board.board[row][col - 1] is NullPiece);
          }
          case BoardDirection.RIGHT: {
            return (col < 7 && _board.board[row][col + 1] is NullPiece);
          }
        } // end switch direction
      } // end case DOT
      case PieceShape.SQUARE: {
        switch (direction) {
          case BoardDirection.UP:{
            return (row > 0 && _board.board[row - 1][col] is NullPiece && _board.board[row - 1][col + 1] is NullPiece);
          }
          case BoardDirection.DOWN: {
            return (row < 6 && _board.board[row + 2][col] is NullPiece && _board.board[row + 2][col + 1] is NullPiece);
          }
          case BoardDirection.LEFT: {
            return (col > 0 && _board.board[row][col - 1] is NullPiece && _board.board[row + 1][col - 1] is NullPiece);
          }
          case BoardDirection.RIGHT: {
            return (col < 6 && _board.board[row][col + 2] is NullPiece && _board.board[row + 1][col + 2] is NullPiece);
          }
        } // end switch direction
      } // end case SQUARE
      case PieceShape.LINE: {
        if (piece.rotation == PieceRotation.UP || piece.rotation == PieceRotation.DOWN) {
          switch (direction) {
            case BoardDirection.UP:{
              return (row > 0 && _board.board[row - 1][col] is NullPiece && _board.board[row - 1][col + 1] is NullPiece);
            }
            case BoardDirection.DOWN: {
              return (row < 7 && _board.board[row + 1][col] is NullPiece && _board.board[row + 1][col + 1] is NullPiece);
            }
            case BoardDirection.LEFT: {
              return (col > 0 && _board.board[row][col - 1] is NullPiece);
            }
            case BoardDirection.RIGHT: {
              return (col < 6 && _board.board[row][col + 2] is NullPiece);
            }
          } // end switch direction para piezas horizontales

        } else if (piece.rotation == PieceRotation.LEFT || piece.rotation == PieceRotation.RIGHT) {
          switch (direction) {
            case BoardDirection.UP:{
              return (row > 0 && _board.board[row - 1][col] is NullPiece);
            }
            case BoardDirection.DOWN: {
              return (row < 6 && _board.board[row + 2][col] is NullPiece);
            }
            case BoardDirection.LEFT: {
              return (col > 0 && _board.board[row][col - 1] is NullPiece && _board.board[row + 1][col - 1] is NullPiece);
            }
            case BoardDirection.RIGHT: {
              return (col < 7 && _board.board[row][col + 1] is NullPiece && _board.board[row + 1][col + 1] is NullPiece);
            }
          } // end switch direction para piezas verticales
        }
      }
      break;
      case PieceShape.L: {
        // TODO: manejar el caso de la L
        // TODO: para todas las rotaciones...
        // TODO: ver todas las direcciones
        return false;
      }
    }

    // Caso no esperado
    return false;
  }

  @override
  bool checkExit({required Piece piece}) {
    // TODO: implement checkExit

    return false;
  }

  @override
  void createAudioLevelOne() {
    // TODO: implement createAudioLevelOne
  }

  @override
  void createAudioLevelThree() {
    // TODO: implement createAudioLevelThree
    createAudioLevelOne();
  }

  @override
  void createAudioLevelTwo() {
    // TODO: implement createAudioLevelTwo
    createAudioLevelOne();
  }

  @override
  void createSpatialLevelOne() {
    // TODO: implement createSpatialLevelOne
  }

  @override
  void createSpatialLevelThree() {
    // TODO: implement createSpatialLevelThree
    createSpatialLevelOne();
  }

  @override
  void createSpatialLevelTwo() {
    // TODO: implement createSpatialLevelTwo
    createSpatialLevelOne();
  }

  @override
  bool movePiece({required BoardDirection direction, required Piece piece}) {
    // Es un movimiento válido en términos de colisiones?
    if (checkCollision(direction: direction, piece: piece)) {

      // Movimiento válido, mover pieza
      moveReferencesOnBoard(direction: direction, piece: piece);

      // Si fue en dirección derecha...
      // Salió la pieza?
      if (direction == BoardDirection.RIGHT && checkExit(piece: piece)) {
        // todo: agregar pieza a bag
        pieceCleanup(piece: piece);
      }
    }

    return false;
  }

  @override
  void moveReferencesOnBoard({required BoardDirection direction, required Piece piece}) {
    // TODO: implement moveReferencesOnBoard
  }

  @override
  void pieceCleanup({required Piece piece}) {
    // TODO: implement pieceCleanup
  }
}