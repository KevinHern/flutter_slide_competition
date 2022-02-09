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
        switch (piece.rotation) {
          case PieceRotation.UP: {

            switch (direction) {
              case BoardDirection.UP:{
                return (row > 0 && _board.board[row - 1][col] is NullPiece && _board.board[row][col + 1] is NullPiece);
              }
              case BoardDirection.DOWN: {
                return (row < 6 && _board.board[row + 2][col] is NullPiece && _board.board[row + 2][col + 1] is NullPiece);
              }
              case BoardDirection.LEFT: {
                return (col > 0 && _board.board[row][col - 1] is NullPiece && _board.board[row + 1][col - 1] is NullPiece);
              }
              case BoardDirection.RIGHT: {
                return (col < 6 && _board.board[row][col + 1] is NullPiece && _board.board[row + 1][col + 2] is NullPiece);
              }
            } // end switch direction

          } // end case L UP

          case PieceRotation.DOWN: {

            switch (direction) {
              case BoardDirection.UP:{
                return (row > 0 && _board.board[row - 1][col] is NullPiece && _board.board[row - 1][col + 1] is NullPiece);
              }
              case BoardDirection.DOWN: {
                return (row < 6 && _board.board[row + 1][col] is NullPiece && _board.board[row + 2][col + 1] is NullPiece);
              }
              case BoardDirection.LEFT: {
                return (col > 0 && _board.board[row][col - 1] is NullPiece && _board.board[row + 1][col] is NullPiece);
              }
              case BoardDirection.RIGHT: {
                return (col < 6 && _board.board[row][col + 2] is NullPiece && _board.board[row + 1][col + 2] is NullPiece);
              }
            } // end switch direction

          } // end case L DOWN

          case PieceRotation.LEFT: {

            switch (direction) {
              case BoardDirection.UP:{
                return (row > 0 && _board.board[row][col] is NullPiece && _board.board[row - 1][col + 1] is NullPiece);
              }
              case BoardDirection.DOWN: {
                return (row < 6 && _board.board[row + 2][col] is NullPiece && _board.board[row + 2][col + 1] is NullPiece);
              }
              case BoardDirection.LEFT: {
                return (col > 0 && _board.board[row][col] is NullPiece && _board.board[row + 1][col - 1] is NullPiece);
              }
              case BoardDirection.RIGHT: {
                return (col < 6 && _board.board[row][col + 2] is NullPiece && _board.board[row + 1][col + 2] is NullPiece);
              }
            } // end switch direction

          } // end case L LEFT

          case PieceRotation.RIGHT: {

            switch (direction) {
              case BoardDirection.UP:{
                return (row > 0 && _board.board[row - 1][col] is NullPiece && _board.board[row - 1][col + 1] is NullPiece);
              }
              case BoardDirection.DOWN: {
                return (row < 6 && _board.board[row + 2][col] is NullPiece && _board.board[row + 1][col + 1] is NullPiece);
              }
              case BoardDirection.LEFT: {
                return (col > 0 && _board.board[row][col - 1] is NullPiece && _board.board[row + 1][col - 1] is NullPiece);
              }
              case BoardDirection.RIGHT: {
                return (col < 6 && _board.board[row][col + 2] is NullPiece && _board.board[row + 1][col + 1] is NullPiece);
              }
            } // end switch direction

          } // end case L RIGHT
        }
      }
    }

    // Caso no esperado
    return false;
  }

  @override
  bool checkExit({required Piece piece}) {
    // posicion actual de pieza
    int row = piece.y;
    int col = piece.x;

    switch (piece.shape) {

      case PieceShape.DOT:
        return (col == 7 && (row == 3 || row == 4));
      case PieceShape.SQUARE:
        return (col == 6 && row == 3);
      case PieceShape.LINE: {
        // horizontal
        if (piece.rotation == PieceRotation.UP || piece.rotation == PieceRotation.DOWN) {
          return (col == 6 && (row == 3 || row == 4));
        // vertical
        } else if (piece.rotation == PieceRotation.LEFT || piece.rotation == PieceRotation.RIGHT) {
          return (col == 7 && row == 3);
        }
      }
        break;
      case PieceShape.L:
        return (col == 6 && row == 3);
    }

    // Caso no esperado
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

    // Es un movimiento válido dentro del tablero?
    // salir del tablero NO cae en esta categoría
    if (checkCollision(direction: direction, piece: piece)) {

      // Movimiento válido, mover pieza
      moveReferencesOnBoard(direction: direction, piece: piece);
      return true;

    // Es un movimiento de salida del tablero?
    } else if (direction == BoardDirection.RIGHT && checkExit(piece: piece)) {

      // Movimiento válido, sacar pieza y poner en bolsa
      // TODO: Poner pieza en bolsa
      pieceCleanup(piece: piece);
      return true;

    }

    // Cualquier otro caso, no se pudo realizar el movimiento
    return false;
  }

  @override
  void moveReferencesOnBoard({required BoardDirection direction, required Piece piece}) {
    // posicion actual de pieza
    int row = piece.y;
    int col = piece.x;

    switch (piece.shape) {
      case PieceShape.DOT: {
        switch (direction) {
          case BoardDirection.UP: {
            _board.board[row - 1][col] = _board.board[row][col];
            _board.board[row][col] = NullPiece();
          }
          break;
          case BoardDirection.DOWN: {
            _board.board[row + 1][col] = _board.board[row][col];
            _board.board[row][col] = NullPiece();
          }
          break;
          case BoardDirection.LEFT: {
            _board.board[row][col - 1] = _board.board[row][col];
            _board.board[row][col] = NullPiece();
          }
          break;
          case BoardDirection.RIGHT: {
            _board.board[row][col + 1] = _board.board[row][col];
            _board.board[row][col] = NullPiece();
          }
          break;
        } // end switch direction
      } // end case DOT
      break;

      case PieceShape.SQUARE: {
        switch (direction) {
          case BoardDirection.UP:{
            _board.board[row - 1][col] = _board.board[row][col];
            _board.board[row - 1][col + 1] = _board.board[row][col + 1];
            _board.board[row + 1][col] = NullPiece();
            _board.board[row + 1][col + 1] = NullPiece();
          }
          break;
          case BoardDirection.DOWN: {
            _board.board[row + 2][col] = _board.board[row][col];
            _board.board[row + 2][col + 1] = _board.board[row][col + 1];
            _board.board[row][col] = NullPiece();
            _board.board[row][col + 1] = NullPiece();
          }
          break;
          case BoardDirection.LEFT: {
            _board.board[row][col - 1] = _board.board[row][col];
            _board.board[row + 1][col - 1] = _board.board[row + 1][col];
            _board.board[row][col + 1] = NullPiece();
            _board.board[row + 1][col + 1] = NullPiece();
          }
          break;
          case BoardDirection.RIGHT: {
            _board.board[row][col + 2] = _board.board[row][col];
            _board.board[row + 1][col + 2] = _board.board[row + 1][col];
            _board.board[row][col] = NullPiece();
            _board.board[row + 1][col] = NullPiece();
          }
          break;
        } // end switch direction
      } // end case SQUARE
      break;

      case PieceShape.LINE: {
        if (piece.rotation == PieceRotation.UP || piece.rotation == PieceRotation.DOWN) {
          switch (direction) {
            case BoardDirection.UP:{
              _board.board[row - 1][col] = _board.board[row][col];
              _board.board[row - 1][col + 1] = _board.board[row][col + 1];
              _board.board[row][col] = NullPiece();
              _board.board[row][col + 1] = NullPiece();
            }
            break;
            case BoardDirection.DOWN: {
              _board.board[row + 1][col] = _board.board[row][col];
              _board.board[row + 1][col + 1] = _board.board[row][col + 1];
              _board.board[row][col] = NullPiece();
              _board.board[row][col + 1] = NullPiece();
            }
            break;
            case BoardDirection.LEFT: {
              _board.board[row][col - 1] = _board.board[row][col];
              _board.board[row][col + 1] = NullPiece();
            }
            break;
            case BoardDirection.RIGHT: {
              _board.board[row][col + 2] = _board.board[row][col];
              _board.board[row][col] = NullPiece();
            }
            break;
          } // end switch direction

        } else if (piece.rotation == PieceRotation.LEFT || piece.rotation == PieceRotation.RIGHT) {
          switch (direction) {
            case BoardDirection.UP:{
              _board.board[row - 1][col] = _board.board[row][col];
              _board.board[row + 1][col] = NullPiece();
            }
            break;
            case BoardDirection.DOWN: {
              _board.board[row + 2][col] = _board.board[row][col];
              _board.board[row][col] = NullPiece();
            }
            break;
            case BoardDirection.LEFT: {
              _board.board[row][col - 1] = _board.board[row][col];
              _board.board[row + 1][col - 1] = _board.board[row + 1][col];
              _board.board[row][col] = NullPiece();
              _board.board[row + 1][col] = NullPiece();
            }
            break;
            case BoardDirection.RIGHT: {
              _board.board[row][col + 1] = _board.board[row][col];
              _board.board[row + 1][col + 1] = _board.board[row + 1][col];
              _board.board[row][col] = NullPiece();
              _board.board[row + 1][col] = NullPiece();
            }
            break;
          } // end switch direction
        }
      }
      break;

      case PieceShape.L: {
        switch (piece.rotation) {
          case PieceRotation.UP: {

            switch (direction) {
              case BoardDirection.UP:{
                _board.board[row - 1][col] = _board.board[row][col];
                _board.board[row][col + 1] = _board.board[row + 1][col + 1];
                _board.board[row + 1][col] = NullPiece();
                _board.board[row + 1][col + 1] = NullPiece();
              }
              break;
              case BoardDirection.DOWN: {
                _board.board[row + 2][col] = _board.board[row + 1][col];
                _board.board[row + 2][col + 1] = _board.board[row + 1][col + 1];
                _board.board[row][col] = NullPiece();
                _board.board[row + 1][col + 1] = NullPiece();
              }
              break;
              case BoardDirection.LEFT: {
                _board.board[row][col - 1] = _board.board[row][col];
                _board.board[row + 1][col - 1] = _board.board[row + 1][col];
                _board.board[row][col] = NullPiece();
                _board.board[row + 1][col + 1] = NullPiece();
              }
              break;
              case BoardDirection.RIGHT: {
                _board.board[row][col + 1] = _board.board[row][col];
                _board.board[row + 1][col + 2] = _board.board[row + 1][col + 1];
                _board.board[row][col] = NullPiece();
                _board.board[row + 1][col] = NullPiece();
              }
              break;
            } // end switch direction

          } // end case L UP
          break;

          case PieceRotation.DOWN: {

            switch (direction) {
              case BoardDirection.UP:{
                _board.board[row - 1][col] = _board.board[row][col];
                _board.board[row - 1][col + 1] = _board.board[row][col + 1];
                _board.board[row][col] = NullPiece();
                _board.board[row + 1][col + 1] = NullPiece();
              }
              break;
              case BoardDirection.DOWN: {
                _board.board[row + 1][col] = _board.board[row][col];
                _board.board[row + 2][col + 1] = _board.board[row + 1][col + 1];
                _board.board[row][col] = NullPiece();
                _board.board[row][col + 1] = NullPiece();
              }
              break;
              case BoardDirection.LEFT: {
                _board.board[row][col - 1] = _board.board[row][col];
                _board.board[row + 1][col] = _board.board[row + 1][col + 1];
                _board.board[row][col + 1] = NullPiece();
                _board.board[row + 1][col + 1] = NullPiece();
              }
              break;
              case BoardDirection.RIGHT: {
                _board.board[row][col + 2] = _board.board[row][col + 1];
                _board.board[row + 1][col + 2] = _board.board[row + 1][col + 1];
                _board.board[row][col] = NullPiece();
                _board.board[row + 1][col + 1] = NullPiece();
              }
              break;
            } // end switch direction

          } // end case L DOWN
          break;

          case PieceRotation.LEFT: {

            switch (direction) {
              case BoardDirection.UP:{
                _board.board[row - 1][col + 1] = _board.board[row][col + 1];
                _board.board[row][col] = _board.board[row + 1][col];
                _board.board[row + 1][col] = NullPiece();
                _board.board[row + 1][col + 1] = NullPiece();
              }
              break;
              case BoardDirection.DOWN: {
                _board.board[row + 2][col] = _board.board[row + 1][col];
                _board.board[row + 2][col + 1] = _board.board[row + 1][col + 1];
                _board.board[row][col + 1] = NullPiece();
                _board.board[row + 1][col] = NullPiece();
              }
              break;
              case BoardDirection.LEFT: {
                _board.board[row][col] = _board.board[row][col + 1];
                _board.board[row + 1][col - 1] = _board.board[row + 1][col];
                _board.board[row][col + 1] = NullPiece();
                _board.board[row + 1][col + 1] = NullPiece();
              }
              break;
              case BoardDirection.RIGHT: {
                _board.board[row][col + 2] = _board.board[row][col + 1];
                _board.board[row + 1][col + 2] = _board.board[row + 1][col + 1];
                _board.board[row][col + 1] = NullPiece();
                _board.board[row + 1][col] = NullPiece();
              }
              break;
            } // end switch direction

          } // end case L LEFT
          break;

          case PieceRotation.RIGHT: {

            switch (direction) {
              case BoardDirection.UP:{
                _board.board[row - 1][col] = _board.board[row][col];
                _board.board[row - 1][col + 1] = _board.board[row][col + 1];
                _board.board[row][col + 1] = NullPiece();
                _board.board[row + 1][col] = NullPiece();
              }
              break;
              case BoardDirection.DOWN: {
                _board.board[row + 1][col + 1] = _board.board[row][col + 1];
                _board.board[row + 2][col] = _board.board[row + 1][col];
                _board.board[row][col] = NullPiece();
                _board.board[row][col + 1] = NullPiece();
              }
              break;
              case BoardDirection.LEFT: {
                _board.board[row][col - 1] = _board.board[row][col];
                _board.board[row + 1][col - 1] = _board.board[row + 1][col];
                _board.board[row][col + 1] = NullPiece();
                _board.board[row + 1][col] = NullPiece();
              }
              break;
              case BoardDirection.RIGHT: {
                _board.board[row][col + 2] = _board.board[row][col + 1];
                _board.board[row + 1][col + 1] = _board.board[row + 1][col];
                _board.board[row][col] = NullPiece();
                _board.board[row + 1][col] = NullPiece();
              }
              break;
            } // end switch direction

          } // end case L RIGHT
          break;
        }
      }
    }
  }

  @override
  void pieceCleanup({required Piece piece}) {
    // TODO: implement pieceCleanup
  }
}