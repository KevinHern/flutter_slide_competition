// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/board.dart';
import 'package:flutter_slide_competition/dev/data/models/sound.dart';

// Contracts
import 'package:flutter_slide_competition/dev/domain/repositories/board_management_contract.dart';

class BoardManagementRepositoryImpl implements BoardManagementRepository {
  late final Board _board;
  static Piece nullPiece = Piece.createNullPiece();

  BoardManagementRepositoryImpl({required Board board}) {
    this._board = board;
  }

  @override
  bool checkCollision(
      {required BoardDirection direction, required Piece piece}) {
    // posicion actual de pieza
    int row = piece.y;
    int col = piece.x;

    switch (piece.shape) {
      case PieceShape.DOT:
        {
          switch (direction) {
            case BoardDirection.UP:
              {
                return (row > 0 && _board.board[row - 1][col].isNullPiece);
              }
            case BoardDirection.DOWN:
              {
                return (row < 7 && _board.board[row + 1][col].isNullPiece);
              }
            case BoardDirection.LEFT:
              {
                return (col > 0 && _board.board[row][col - 1].isNullPiece);
              }
            case BoardDirection.RIGHT:
              {
                return (col < 7 && _board.board[row][col + 1].isNullPiece);
              }
          } // end switch direction
        } // end case DOT

      case PieceShape.SQUARE:
        {
          switch (direction) {
            case BoardDirection.UP:
              {
                return (row > 0 &&
                    _board.board[row - 1][col].isNullPiece &&
                    _board.board[row - 1][col + 1].isNullPiece);
              }
            case BoardDirection.DOWN:
              {
                return (row < 6 &&
                    _board.board[row + 2][col].isNullPiece &&
                    _board.board[row + 2][col + 1].isNullPiece);
              }
            case BoardDirection.LEFT:
              {
                return (col > 0 &&
                    _board.board[row][col - 1].isNullPiece &&
                    _board.board[row + 1][col - 1].isNullPiece);
              }
            case BoardDirection.RIGHT:
              {
                return (col < 6 &&
                    _board.board[row][col + 2].isNullPiece &&
                    _board.board[row + 1][col + 2].isNullPiece);
              }
          } // end switch direction
        } // end case SQUARE

      case PieceShape.LINE:
        {
          if (piece.rotation == PieceRotation.UP ||
              piece.rotation == PieceRotation.DOWN) {
            switch (direction) {
              case BoardDirection.UP:
                {
                  return (row > 0 &&
                      _board.board[row - 1][col].isNullPiece &&
                      _board.board[row - 1][col + 1].isNullPiece);
                }
              case BoardDirection.DOWN:
                {
                  return (row < 7 &&
                      _board.board[row + 1][col].isNullPiece &&
                      _board.board[row + 1][col + 1].isNullPiece);
                }
              case BoardDirection.LEFT:
                {
                  return (col > 0 && _board.board[row][col - 1].isNullPiece);
                }
              case BoardDirection.RIGHT:
                {
                  return (col < 6 && _board.board[row][col + 2].isNullPiece);
                }
            } // end switch direction para piezas horizontales

          } else if (piece.rotation == PieceRotation.LEFT ||
              piece.rotation == PieceRotation.RIGHT) {
            switch (direction) {
              case BoardDirection.UP:
                {
                  return (row > 0 && _board.board[row - 1][col].isNullPiece);
                }
              case BoardDirection.DOWN:
                {
                  return (row < 6 && _board.board[row + 2][col].isNullPiece);
                }
              case BoardDirection.LEFT:
                {
                  return (col > 0 &&
                      _board.board[row][col - 1].isNullPiece &&
                      _board.board[row + 1][col - 1].isNullPiece);
                }
              case BoardDirection.RIGHT:
                {
                  return (col < 7 &&
                      _board.board[row][col + 1].isNullPiece &&
                      _board.board[row + 1][col + 1].isNullPiece);
                }
            } // end switch direction para piezas verticales
          }
        }
        break;

      case PieceShape.L:
        {
          switch (piece.rotation) {
            case PieceRotation.UP:
              {
                switch (direction) {
                  case BoardDirection.UP:
                    {
                      return (row > 0 &&
                          _board.board[row - 1][col].isNullPiece &&
                          _board.board[row][col + 1].isNullPiece);
                    }
                  case BoardDirection.DOWN:
                    {
                      return (row < 6 &&
                          _board.board[row + 2][col].isNullPiece &&
                          _board.board[row + 2][col + 1].isNullPiece);
                    }
                  case BoardDirection.LEFT:
                    {
                      return (col > 0 &&
                          _board.board[row][col - 1].isNullPiece &&
                          _board.board[row + 1][col - 1].isNullPiece);
                    }
                  case BoardDirection.RIGHT:
                    {
                      return (col < 6 &&
                          _board.board[row][col + 1].isNullPiece &&
                          _board.board[row + 1][col + 2].isNullPiece);
                    }
                } // end switch direction

              } // end case L UP

            case PieceRotation.DOWN:
              {
                switch (direction) {
                  case BoardDirection.UP:
                    {
                      return (row > 0 &&
                          _board.board[row - 1][col].isNullPiece &&
                          _board.board[row - 1][col + 1].isNullPiece);
                    }
                  case BoardDirection.DOWN:
                    {
                      return (row < 6 &&
                          _board.board[row + 1][col].isNullPiece &&
                          _board.board[row + 2][col + 1].isNullPiece);
                    }
                  case BoardDirection.LEFT:
                    {
                      return (col > 0 &&
                          _board.board[row][col - 1].isNullPiece &&
                          _board.board[row + 1][col].isNullPiece);
                    }
                  case BoardDirection.RIGHT:
                    {
                      return (col < 6 &&
                          _board.board[row][col + 2].isNullPiece &&
                          _board.board[row + 1][col + 2].isNullPiece);
                    }
                } // end switch direction

              } // end case L DOWN

            case PieceRotation.LEFT:
              {
                switch (direction) {
                  case BoardDirection.UP:
                    {
                      return (row > 0 &&
                          _board.board[row][col].isNullPiece &&
                          _board.board[row - 1][col + 1].isNullPiece);
                    }
                  case BoardDirection.DOWN:
                    {
                      return (row < 6 &&
                          _board.board[row + 2][col].isNullPiece &&
                          _board.board[row + 2][col + 1].isNullPiece);
                    }
                  case BoardDirection.LEFT:
                    {
                      return (col > 0 &&
                          _board.board[row][col].isNullPiece &&
                          _board.board[row + 1][col - 1].isNullPiece);
                    }
                  case BoardDirection.RIGHT:
                    {
                      return (col < 6 &&
                          _board.board[row][col + 2].isNullPiece &&
                          _board.board[row + 1][col + 2].isNullPiece);
                    }
                } // end switch direction

              } // end case L LEFT

            case PieceRotation.RIGHT:
              {
                switch (direction) {
                  case BoardDirection.UP:
                    {
                      return (row > 0 &&
                          _board.board[row - 1][col].isNullPiece &&
                          _board.board[row - 1][col + 1].isNullPiece);
                    }
                  case BoardDirection.DOWN:
                    {
                      return (row < 6 &&
                          _board.board[row + 2][col].isNullPiece &&
                          _board.board[row + 1][col + 1].isNullPiece);
                    }
                  case BoardDirection.LEFT:
                    {
                      return (col > 0 &&
                          _board.board[row][col - 1].isNullPiece &&
                          _board.board[row + 1][col - 1].isNullPiece);
                    }
                  case BoardDirection.RIGHT:
                    {
                      return (col < 6 &&
                          _board.board[row][col + 2].isNullPiece &&
                          _board.board[row + 1][col + 1].isNullPiece);
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

    // Solo se pueden sacar piezas espaciales y de audio
    // Dummy, empty, etc no se sacan nunca
    if (piece.type != PieceType.SPATIAL && piece.type != PieceType.AUDIO) {
      return false;
    }

    switch (piece.shape) {
      case PieceShape.DOT:
        return (col == 7 && (row == 3 || row == 4));
      case PieceShape.SQUARE:
        return (col == 6 && row == 3);
      case PieceShape.LINE:
        {
          // horizontal
          if (piece.rotation == PieceRotation.UP ||
              piece.rotation == PieceRotation.DOWN) {
            return (col == 6 && (row == 3 || row == 4));

            // vertical
          } else if (piece.rotation == PieceRotation.LEFT ||
              piece.rotation == PieceRotation.RIGHT) {
            return (col == 7 && row == 3);
          }
        }
        break;
      case PieceShape.L:
        {
          if (col == 6 && row == 3) {
            switch (piece.rotation) {
              case PieceRotation.UP:
                return (_board.board[7][3].isNullPiece);
              case PieceRotation.DOWN:
                return true;
              case PieceRotation.LEFT:
                return true;
              case PieceRotation.RIGHT:
                return (_board.board[7][4].isNullPiece);
            }
          } else {
            return false;
          }
        }
    }

    // Caso no esperado
    return false;
  }

  @override
  void createAudioLevelOne({required board}) {
    // Adding Fixed Pieces
    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.RIGHT,
        type: PieceType.FIXED,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 0,
      col: 0,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 0,
      col: 2,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 0,
      col: 4,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.DOWN,
        type: PieceType.FIXED,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 0,
      col: 6,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.FIXED,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 2,
      col: 0,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.FIXED,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 4,
      col: 0,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 6,
      col: 0,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 7,
      col: 2,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 7,
      col: 4,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.FIXED,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 6,
      col: 6,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 5,
      col: 7,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 2,
      col: 7,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 2,
      col: 4,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 4,
      col: 5,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 5,
      col: 3,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 3,
      col: 2,
    );

    // Adding Dummy Pieces
    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.DUMMY,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 3,
      col: 1,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.RIGHT,
        type: PieceType.DUMMY,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 1,
      col: 3,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.DOWN,
        type: PieceType.DUMMY,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 3,
      col: 5,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.DUMMY,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 5,
      col: 3,
    );

    // Adding Sound Pieces
    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.AUDIO,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
        musicalNote: MusicalNote.C,
      ),
      row: 2,
      col: 2,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.AUDIO,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
        musicalNote: MusicalNote.D,
      ),
      row: 5,
      col: 2,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.AUDIO,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
        musicalNote: MusicalNote.E,
      ),
      row: 2,
      col: 5,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.AUDIO,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
        musicalNote: MusicalNote.G,
      ),
      row: 5,
      col: 5,
    );
  }

  @override
  void createAudioLevelTwo({required board}) {
    // Adding Fixed Pieces
    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.RIGHT,
        type: PieceType.FIXED,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 0,
      col: 0,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 0,
      col: 2,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 0,
      col: 4,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.DOWN,
        type: PieceType.FIXED,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 0,
      col: 6,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.FIXED,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 2,
      col: 0,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.FIXED,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 4,
      col: 0,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 6,
      col: 0,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 7,
      col: 2,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 7,
      col: 4,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.FIXED,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 6,
      col: 6,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 5,
      col: 7,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 2,
      col: 7,
    );

    // Adding Dummy Pieces

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.RIGHT,
        type: PieceType.DUMMY,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 2,
      col: 2,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.DOWN,
        type: PieceType.DUMMY,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 2,
      col: 4,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.DUMMY,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 4,
      col: 2,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.DUMMY,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 4,
      col: 4,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.DUMMY,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 3,
      col: 6,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.DUMMY,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 1,
      col: 2,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.DUMMY,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 1,
      col: 5,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.DUMMY,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 6,
      col: 2,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.DUMMY,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 6,
      col: 5,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.DUMMY,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 2,
      col: 1,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.DUMMY,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 5,
      col: 1,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.DUMMY,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 2,
      col: 6,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.DUMMY,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 5,
      col: 6,
    );

    // Placing Sound Pieces
    board.addPiece(
      piece: Piece.withDetails(
          rotation: PieceRotation.UP,
          type: PieceType.AUDIO,
          shape: PieceShape.SQUARE,
          location: PieceLocation.BOARD,
          musicalNote: MusicalNote.C8),
      row: 3,
      col: 3,
    );

    board.addPiece(
      piece: Piece.withDetails(
          rotation: PieceRotation.UP,
          type: PieceType.AUDIO,
          shape: PieceShape.DOT,
          location: PieceLocation.BOARD,
          musicalNote: MusicalNote.A),
      row: 1,
      col: 1,
    );

    board.addPiece(
      piece: Piece.withDetails(
          rotation: PieceRotation.UP,
          type: PieceType.AUDIO,
          shape: PieceShape.LINE,
          location: PieceLocation.BOARD,
          musicalNote: MusicalNote.B),
      row: 6,
      col: 3,
    );

    board.addPiece(
      piece: Piece.withDetails(
          rotation: PieceRotation.UP,
          type: PieceType.AUDIO,
          shape: PieceShape.DOT,
          location: PieceLocation.BOARD,
          musicalNote: MusicalNote.G),
      row: 6,
      col: 6,
    );
  }

  @override
  void createAudioLevelThree({required board}) {
    // Adding Fixed Pieces
    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.RIGHT,
        type: PieceType.FIXED,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 0,
      col: 0,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 0,
      col: 2,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 0,
      col: 4,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.DOWN,
        type: PieceType.FIXED,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 0,
      col: 6,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.FIXED,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 2,
      col: 0,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.FIXED,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 4,
      col: 0,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 6,
      col: 0,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 7,
      col: 2,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 7,
      col: 4,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.FIXED,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 6,
      col: 6,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 5,
      col: 7,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.FIXED,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 2,
      col: 7,
    );

    // Placing Dummy Pieces
    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.DUMMY,
        shape: PieceShape.SQUARE,
        location: PieceLocation.BOARD,
      ),
      row: 2,
      col: 3,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.DUMMY,
        shape: PieceShape.SQUARE,
        location: PieceLocation.BOARD,
      ),
      row: 4,
      col: 3,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.RIGHT,
        type: PieceType.DUMMY,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 2,
      col: 5,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.DUMMY,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 4,
      col: 5,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.DUMMY,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 1,
      col: 5,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.DUMMY,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 3,
      col: 1,
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.DUMMY,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 2,
      col: 2,
    );

    // Placing Sound Pieces
    board.addPiece(
      piece: Piece.withDetails(
          rotation: PieceRotation.RIGHT,
          type: PieceType.AUDIO,
          shape: PieceShape.L,
          location: PieceLocation.BOARD,
          musicalNote: MusicalNote.C),
      row: 1,
      col: 1,
    );

    board.addPiece(
      piece: Piece.withDetails(
          rotation: PieceRotation.UP,
          type: PieceType.AUDIO,
          shape: PieceShape.L,
          location: PieceLocation.BOARD,
          musicalNote: MusicalNote.A),
      row: 5,
      col: 1,
    );

    board.addPiece(
      piece: Piece.withDetails(
          rotation: PieceRotation.UP,
          type: PieceType.AUDIO,
          shape: PieceShape.LINE,
          location: PieceLocation.BOARD,
          musicalNote: MusicalNote.G),
      row: 6,
      col: 4,
    );

    board.addPiece(
      piece: Piece.withDetails(
          rotation: PieceRotation.UP,
          type: PieceType.AUDIO,
          shape: PieceShape.DOT,
          location: PieceLocation.BOARD,
          musicalNote: MusicalNote.E),
      row: 1,
      col: 6,
    );
  }

  @override
  void createSpatialLevelOne({required board}) {
    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.SPATIAL,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 3,
      col: 5,
    );
    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.SPATIAL,
        shape: PieceShape.SQUARE,
        location: PieceLocation.BOARD,
        musicalNote: MusicalNote.B,
      ),
      row: 3,
      col: 3,
    );
    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.AUDIO,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
        musicalNote: MusicalNote.C,
      ),
      row: 3,
      col: 1,
    );
  }

  @override
  void createSpatialLevelThree({required board}) {
    // TODO: implement createSpatialLevelThree
    createSpatialLevelOne(board: board);
  }

  @override
  void createSpatialLevelTwo({required board}) {
    // TODO: implement createSpatialLevelTwo
    createSpatialLevelOne(board: board);
  }

  @override
  Piece movePiece({required BoardDirection direction, required Piece piece}) {
    if (piece.location != PieceLocation.BOARD) {
      return nullPiece;
    }

    // Es un movimiento válido dentro del tablero?
    // salir del tablero NO cae en esta categoría
    if (checkCollision(direction: direction, piece: piece)) {
      // Movimiento válido, mover pieza
      moveReferencesOnBoard(direction: direction, piece: piece);
      return nullPiece;

      // Es un movimiento de salida del tablero?
    } else if (direction == BoardDirection.RIGHT && checkExit(piece: piece)) {
      // Movimiento válido, sacar pieza y poner en bolsa
      pieceCleanup(piece: piece);
      return piece;
    }

    // Cualquier otro caso, no se pudo realizar el movimiento
    return nullPiece;
  }

  @override
  void moveReferencesOnBoard(
      {required BoardDirection direction, required Piece piece}) {
    // posicion actual de pieza
    int row = piece.y;
    int col = piece.x;

    switch (piece.shape) {
      case PieceShape.DOT:
        {
          switch (direction) {
            case BoardDirection.UP:
              {
                _board.board[row - 1][col] = _board.board[row][col];
                _board.board[row][col] = nullPiece;
              }
              break;
            case BoardDirection.DOWN:
              {
                _board.board[row + 1][col] = _board.board[row][col];
                _board.board[row][col] = nullPiece;
              }
              break;
            case BoardDirection.LEFT:
              {
                _board.board[row][col - 1] = _board.board[row][col];
                _board.board[row][col] = nullPiece;
              }
              break;
            case BoardDirection.RIGHT:
              {
                _board.board[row][col + 1] = _board.board[row][col];
                _board.board[row][col] = nullPiece;
              }
              break;
          } // end switch direction
        } // end case DOT
        break;

      case PieceShape.SQUARE:
        {
          switch (direction) {
            case BoardDirection.UP:
              {
                _board.board[row - 1][col] = _board.board[row][col];
                _board.board[row - 1][col + 1] = _board.board[row][col + 1];
                _board.board[row + 1][col] = nullPiece;
                _board.board[row + 1][col + 1] = nullPiece;
              }
              break;
            case BoardDirection.DOWN:
              {
                _board.board[row + 2][col] = _board.board[row][col];
                _board.board[row + 2][col + 1] = _board.board[row][col + 1];
                _board.board[row][col] = nullPiece;
                _board.board[row][col + 1] = nullPiece;
              }
              break;
            case BoardDirection.LEFT:
              {
                _board.board[row][col - 1] = _board.board[row][col];
                _board.board[row + 1][col - 1] = _board.board[row + 1][col];
                _board.board[row][col + 1] = nullPiece;
                _board.board[row + 1][col + 1] = nullPiece;
              }
              break;
            case BoardDirection.RIGHT:
              {
                _board.board[row][col + 2] = _board.board[row][col];
                _board.board[row + 1][col + 2] = _board.board[row + 1][col];
                _board.board[row][col] = nullPiece;
                _board.board[row + 1][col] = nullPiece;
              }
              break;
          } // end switch direction
        } // end case SQUARE
        break;

      case PieceShape.LINE:
        {
          if (piece.rotation == PieceRotation.UP ||
              piece.rotation == PieceRotation.DOWN) {
            switch (direction) {
              case BoardDirection.UP:
                {
                  _board.board[row - 1][col] = _board.board[row][col];
                  _board.board[row - 1][col + 1] = _board.board[row][col + 1];
                  _board.board[row][col] = nullPiece;
                  _board.board[row][col + 1] = nullPiece;
                }
                break;
              case BoardDirection.DOWN:
                {
                  _board.board[row + 1][col] = _board.board[row][col];
                  _board.board[row + 1][col + 1] = _board.board[row][col + 1];
                  _board.board[row][col] = nullPiece;
                  _board.board[row][col + 1] = nullPiece;
                }
                break;
              case BoardDirection.LEFT:
                {
                  _board.board[row][col - 1] = _board.board[row][col];
                  _board.board[row][col + 1] = nullPiece;
                }
                break;
              case BoardDirection.RIGHT:
                {
                  _board.board[row][col + 2] = _board.board[row][col];
                  _board.board[row][col] = nullPiece;
                }
                break;
            } // end switch direction

          } else if (piece.rotation == PieceRotation.LEFT ||
              piece.rotation == PieceRotation.RIGHT) {
            switch (direction) {
              case BoardDirection.UP:
                {
                  _board.board[row - 1][col] = _board.board[row][col];
                  _board.board[row + 1][col] = nullPiece;
                }
                break;
              case BoardDirection.DOWN:
                {
                  _board.board[row + 2][col] = _board.board[row][col];
                  _board.board[row][col] = nullPiece;
                }
                break;
              case BoardDirection.LEFT:
                {
                  _board.board[row][col - 1] = _board.board[row][col];
                  _board.board[row + 1][col - 1] = _board.board[row + 1][col];
                  _board.board[row][col] = nullPiece;
                  _board.board[row + 1][col] = nullPiece;
                }
                break;
              case BoardDirection.RIGHT:
                {
                  _board.board[row][col + 1] = _board.board[row][col];
                  _board.board[row + 1][col + 1] = _board.board[row + 1][col];
                  _board.board[row][col] = nullPiece;
                  _board.board[row + 1][col] = nullPiece;
                }
                break;
            } // end switch direction
          }
        }
        break;

      case PieceShape.L:
        {
          switch (piece.rotation) {
            case PieceRotation.UP:
              {
                switch (direction) {
                  case BoardDirection.UP:
                    {
                      _board.board[row - 1][col] = _board.board[row][col];
                      _board.board[row][col + 1] =
                          _board.board[row + 1][col + 1];
                      _board.board[row + 1][col] = nullPiece;
                      _board.board[row + 1][col + 1] = nullPiece;
                    }
                    break;
                  case BoardDirection.DOWN:
                    {
                      _board.board[row + 2][col] = _board.board[row + 1][col];
                      _board.board[row + 2][col + 1] =
                          _board.board[row + 1][col + 1];
                      _board.board[row][col] = nullPiece;
                      _board.board[row + 1][col + 1] = nullPiece;
                    }
                    break;
                  case BoardDirection.LEFT:
                    {
                      _board.board[row][col - 1] = _board.board[row][col];
                      _board.board[row + 1][col - 1] =
                          _board.board[row + 1][col];
                      _board.board[row][col] = nullPiece;
                      _board.board[row + 1][col + 1] = nullPiece;
                    }
                    break;
                  case BoardDirection.RIGHT:
                    {
                      _board.board[row][col + 1] = _board.board[row][col];
                      _board.board[row + 1][col + 2] =
                          _board.board[row + 1][col + 1];
                      _board.board[row][col] = nullPiece;
                      _board.board[row + 1][col] = nullPiece;
                    }
                    break;
                } // end switch direction

              } // end case L UP
              break;

            case PieceRotation.DOWN:
              {
                switch (direction) {
                  case BoardDirection.UP:
                    {
                      _board.board[row - 1][col] = _board.board[row][col];
                      _board.board[row - 1][col + 1] =
                          _board.board[row][col + 1];
                      _board.board[row][col] = nullPiece;
                      _board.board[row + 1][col + 1] = nullPiece;
                    }
                    break;
                  case BoardDirection.DOWN:
                    {
                      _board.board[row + 1][col] = _board.board[row][col];
                      _board.board[row + 2][col + 1] =
                          _board.board[row + 1][col + 1];
                      _board.board[row][col] = nullPiece;
                      _board.board[row][col + 1] = nullPiece;
                    }
                    break;
                  case BoardDirection.LEFT:
                    {
                      _board.board[row][col - 1] = _board.board[row][col];
                      _board.board[row + 1][col] =
                          _board.board[row + 1][col + 1];
                      _board.board[row][col + 1] = nullPiece;
                      _board.board[row + 1][col + 1] = nullPiece;
                    }
                    break;
                  case BoardDirection.RIGHT:
                    {
                      _board.board[row][col + 2] = _board.board[row][col + 1];
                      _board.board[row + 1][col + 2] =
                          _board.board[row + 1][col + 1];
                      _board.board[row][col] = nullPiece;
                      _board.board[row + 1][col + 1] = nullPiece;
                    }
                    break;
                } // end switch direction

              } // end case L DOWN
              break;

            case PieceRotation.LEFT:
              {
                switch (direction) {
                  case BoardDirection.UP:
                    {
                      _board.board[row - 1][col + 1] =
                          _board.board[row][col + 1];
                      _board.board[row][col] = _board.board[row + 1][col];
                      _board.board[row + 1][col] = nullPiece;
                      _board.board[row + 1][col + 1] = nullPiece;
                    }
                    break;
                  case BoardDirection.DOWN:
                    {
                      _board.board[row + 2][col] = _board.board[row + 1][col];
                      _board.board[row + 2][col + 1] =
                          _board.board[row + 1][col + 1];
                      _board.board[row][col + 1] = nullPiece;
                      _board.board[row + 1][col] = nullPiece;
                    }
                    break;
                  case BoardDirection.LEFT:
                    {
                      _board.board[row][col] = _board.board[row][col + 1];
                      _board.board[row + 1][col - 1] =
                          _board.board[row + 1][col];
                      _board.board[row][col + 1] = nullPiece;
                      _board.board[row + 1][col + 1] = nullPiece;
                    }
                    break;
                  case BoardDirection.RIGHT:
                    {
                      _board.board[row][col + 2] = _board.board[row][col + 1];
                      _board.board[row + 1][col + 2] =
                          _board.board[row + 1][col + 1];
                      _board.board[row][col + 1] = nullPiece;
                      _board.board[row + 1][col] = nullPiece;
                    }
                    break;
                } // end switch direction

              } // end case L LEFT
              break;

            case PieceRotation.RIGHT:
              {
                switch (direction) {
                  case BoardDirection.UP:
                    {
                      _board.board[row - 1][col] = _board.board[row][col];
                      _board.board[row - 1][col + 1] =
                          _board.board[row][col + 1];
                      _board.board[row][col + 1] = nullPiece;
                      _board.board[row + 1][col] = nullPiece;
                    }
                    break;
                  case BoardDirection.DOWN:
                    {
                      _board.board[row + 1][col + 1] =
                          _board.board[row][col + 1];
                      _board.board[row + 2][col] = _board.board[row + 1][col];
                      _board.board[row][col] = nullPiece;
                      _board.board[row][col + 1] = nullPiece;
                    }
                    break;
                  case BoardDirection.LEFT:
                    {
                      _board.board[row][col - 1] = _board.board[row][col];
                      _board.board[row + 1][col - 1] =
                          _board.board[row + 1][col];
                      _board.board[row][col + 1] = nullPiece;
                      _board.board[row + 1][col] = nullPiece;
                    }
                    break;
                  case BoardDirection.RIGHT:
                    {
                      _board.board[row][col + 2] = _board.board[row][col + 1];
                      _board.board[row + 1][col + 1] =
                          _board.board[row + 1][col];
                      _board.board[row][col] = nullPiece;
                      _board.board[row + 1][col] = nullPiece;
                    }
                    break;
                } // end switch direction

              } // end case L RIGHT
              break;
          }
        }
    }

    switch (direction) {
      case BoardDirection.UP:
        {
          piece.y = piece.y - 1;
        }
        break;
      case BoardDirection.DOWN:
        {
          piece.y = piece.y + 1;
        }
        break;
      case BoardDirection.LEFT:
        {
          piece.x = piece.x - 1;
        }
        break;
      case BoardDirection.RIGHT:
        {
          piece.x = piece.x + 1;
        }
        break;
    }
  }

  @override
  void pieceCleanup({required Piece piece}) {
    // posicion actual de pieza
    int row = piece.y;
    int col = piece.x;

    piece.location = PieceLocation.BAG;

    switch (piece.shape) {
      case PieceShape.DOT:
        {
          _board.board[row][col] = nullPiece;
        }
        break;
      case PieceShape.SQUARE:
        {
          _board.board[row][col] = nullPiece;
          _board.board[row][col + 1] = nullPiece;
          _board.board[row + 1][col] = nullPiece;
          _board.board[row + 1][col + 1] = nullPiece;
        }
        break;
      case PieceShape.LINE:
        {
          // horizontal
          if (piece.rotation == PieceRotation.UP ||
              piece.rotation == PieceRotation.DOWN) {
            _board.board[row][col] = nullPiece;
            _board.board[row][col + 1] = nullPiece;

            // vertical
          } else if (piece.rotation == PieceRotation.LEFT ||
              piece.rotation == PieceRotation.RIGHT) {
            _board.board[row][col] = nullPiece;
            _board.board[row + 1][col] = nullPiece;
          }
        }
        break;
      case PieceShape.L:
        {
          switch (piece.rotation) {
            case PieceRotation.UP:
              {
                _board.board[row][col] = nullPiece;
                _board.board[row + 1][col] = nullPiece;
                _board.board[row + 1][col + 1] = nullPiece;
              }
              break;
            case PieceRotation.DOWN:
              {
                _board.board[row][col] = nullPiece;
                _board.board[row][col + 1] = nullPiece;
                _board.board[row + 1][col + 1] = nullPiece;
              }
              break;
            case PieceRotation.LEFT:
              {
                _board.board[row][col + 1] = nullPiece;
                _board.board[row + 1][col] = nullPiece;
                _board.board[row + 1][col + 1] = nullPiece;
              }
              break;
            case PieceRotation.RIGHT:
              {
                _board.board[row][col] = nullPiece;
                _board.board[row][col + 1] = nullPiece;
                _board.board[row + 1][col] = nullPiece;
              }
              break;
          }
        }
    }
  }

  @override
  Piece getBasePiece({required int row, required int col}) {
    return _board.board[row][col];
  }
}
