// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/spatial.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/spatial_management_contract.dart';

class SpatialManagementRepositoryImpl implements SpatialManagementRepository {
  late final SpatialManager _model;
  static Piece nullPiece = Piece.createNullPiece();

  SpatialManagementRepositoryImpl({required SpatialManager model}) {
    this._model = model;
  }

  @override
  bool addPiece({required Piece piece, required int row, required int col}) {
    if (checkIfEmptySpace(piece: piece, row: row, col: col)) {

      piece.location = PieceLocation.SPATIAL_BOARD;
      piece.y = row;
      piece.x = col;

      switch(piece.shape) {
        case PieceShape.DOT: {
          _model.userBoard[row][col] = piece;
          break;
        }
        case PieceShape.SQUARE: {
          _model.userBoard[row][col] = piece;
          _model.userBoard[row+1][col] = piece;
          _model.userBoard[row][col+1] = piece;
          _model.userBoard[row+1][col+1] = piece;
          break;
        }
        case PieceShape.LINE: {
          if (piece.rotation == PieceRotation.UP || piece.rotation == PieceRotation.DOWN) {
            // horizontal
            _model.userBoard[row][col] = piece;
            _model.userBoard[row][col+1] = piece;

          } else {
            // vertical
            _model.userBoard[row][col] = piece;
            _model.userBoard[row+1][col] = piece;
          }
          break;
        }
        case PieceShape.L: {

          switch (piece.rotation) {

            case PieceRotation.UP: {
              _model.userBoard[row][col] = piece;
              _model.userBoard[row+1][col] = piece;
              _model.userBoard[row+1][col+1] = piece;
              break;
            }
            case PieceRotation.DOWN: {
              _model.userBoard[row][col] = piece;
              _model.userBoard[row][col+1] = piece;
              _model.userBoard[row+1][col+1] = piece;
              break;
            }
            case PieceRotation.LEFT: {
              _model.userBoard[row][col+1] = piece;
              _model.userBoard[row+1][col] = piece;
              _model.userBoard[row+1][col+1] = piece;
              break;
            }
            case PieceRotation.RIGHT: {
              _model.userBoard[row][col] = piece;
              _model.userBoard[row][col+1] = piece;
              _model.userBoard[row+1][col] = piece;
              break;
            }
          }
        }
      }
      return true;
    } else {
      return false;
    }
  }

  @override
  bool checkIfEmptySpace({required Piece piece, required int row, required int col}) {

    switch(piece.shape) {
      case PieceShape.DOT:
        return _model.userBoard[row][col].isNullPiece;
      case PieceShape.SQUARE:
        return (
          row < 5 && col < 5 &&
              _model.userBoard[row][col].isNullPiece &&
              _model.userBoard[row+1][col].isNullPiece &&
              _model.userBoard[row][col+1].isNullPiece &&
              _model.userBoard[row+1][col+1].isNullPiece
        );
      case PieceShape.LINE: {
        if (piece.rotation == PieceRotation.UP || piece.rotation == PieceRotation.DOWN) {
          // horizontal
          return (
            col < 5 &&
                _model.userBoard[row][col].isNullPiece &&
                _model.userBoard[row][col+1].isNullPiece
          );

        } else {
          // vertical
          return (
              row < 5 &&
                  _model.userBoard[row][col].isNullPiece &&
                  _model.userBoard[row+1][col].isNullPiece
          );
        }
      }
      case PieceShape.L: {
        // Sin importar la rotación ocupa 2x2 en alguna parte
        if (row > 4 || col > 4) return false;

        switch (piece.rotation) {

          case PieceRotation.UP:
            return (
                _model.userBoard[row][col].isNullPiece &&
                    _model.userBoard[row+1][col].isNullPiece &&
                    _model.userBoard[row+1][col+1].isNullPiece
            );
          case PieceRotation.DOWN:
            return (
                _model.userBoard[row][col].isNullPiece &&
                    _model.userBoard[row][col+1].isNullPiece &&
                    _model.userBoard[row+1][col+1].isNullPiece
            );
          case PieceRotation.LEFT:
            return (
                _model.userBoard[row][col+1].isNullPiece &&
                    _model.userBoard[row+1][col].isNullPiece &&
                    _model.userBoard[row+1][col+1].isNullPiece
            );
          case PieceRotation.RIGHT:
            return (
                _model.userBoard[row][col].isNullPiece &&
                    _model.userBoard[row][col+1].isNullPiece &&
                    _model.userBoard[row+1][col].isNullPiece
            );
        }
      }
    }
  }

  @override
  int checkEmptySpace() {
    int empty = 0;

    for (int row = 0; row < 6; row++) {
      for (int col = 0; col < 6; col++) {
        Piece targetPiece = _model.targetBoard[row][col];
        Piece userPiece = _model.userBoard[row][col];

        if (!targetPiece.isNullPiece && userPiece.isNullPiece) empty++;
      }
    }

    return empty;
  }

  @override
  bool compareBoards() {
    for (int row = 0; row < 6; row++) {
      for (int col = 0; col < 6; col++) {
        Piece targetPiece = _model.targetBoard[row][col];
        Piece userPiece = _model.userBoard[row][col];

        if (targetPiece.isNullPiece && !userPiece.isNullPiece) return false;
        if (userPiece.isNullPiece && !targetPiece.isNullPiece) return false;
      }
    }

    return true;
  }

  @override
  Piece getBasePiece({required int row, required int col}) {
    return _model.userBoard[row][col];
  }

  @override
  Piece removePiece({required Piece piece}) {
    // posicion actual de pieza
    int row = piece.y;
    int col = piece.x;

    piece.location = PieceLocation.BAG;

    switch (piece.shape) {
      case PieceShape.DOT:
        {
          _model.userBoard[row][col] = nullPiece;
        }
        break;
      case PieceShape.SQUARE:
        {
          _model.userBoard[row][col] = nullPiece;
          _model.userBoard[row][col + 1] = nullPiece;
          _model.userBoard[row + 1][col] = nullPiece;
          _model.userBoard[row + 1][col + 1] = nullPiece;
        }
        break;
      case PieceShape.LINE:
        {
          // horizontal
          if (piece.rotation == PieceRotation.UP ||
              piece.rotation == PieceRotation.DOWN) {
            _model.userBoard[row][col] = nullPiece;
            _model.userBoard[row][col + 1] = nullPiece;

            // vertical
          } else if (piece.rotation == PieceRotation.LEFT ||
              piece.rotation == PieceRotation.RIGHT) {
            _model.userBoard[row][col] = nullPiece;
            _model.userBoard[row + 1][col] = nullPiece;
          }
        }
        break;
      case PieceShape.L:
        {
          switch (piece.rotation) {
            case PieceRotation.UP:
              {
                _model.userBoard[row][col] = nullPiece;
                _model.userBoard[row + 1][col] = nullPiece;
                _model.userBoard[row + 1][col + 1] = nullPiece;
              }
              break;
            case PieceRotation.DOWN:
              {
                _model.userBoard[row][col] = nullPiece;
                _model.userBoard[row][col + 1] = nullPiece;
                _model.userBoard[row + 1][col + 1] = nullPiece;
              }
              break;
            case PieceRotation.LEFT:
              {
                _model.userBoard[row][col + 1] = nullPiece;
                _model.userBoard[row + 1][col] = nullPiece;
                _model.userBoard[row + 1][col + 1] = nullPiece;
              }
              break;
            case PieceRotation.RIGHT:
              {
                _model.userBoard[row][col] = nullPiece;
                _model.userBoard[row][col + 1] = nullPiece;
                _model.userBoard[row + 1][col] = nullPiece;
              }
              break;
          }
        }
    }

    return piece;
  }

  @override
  void createSpatialLevelOne({required SpatialManager spatialManager}) {
    spatialManager.addPieceToTargetBoard(
        piece: Piece.withDetails(
          rotation: PieceRotation.LEFT,
          type: PieceType.SPATIAL,
          shape: PieceShape.L,
          location: PieceLocation.SPATIAL_BOARD,
        ),
        row: 1,
        col: 1
    );
    spatialManager.addPieceToTargetBoard(
        piece: Piece.withDetails(
          rotation: PieceRotation.UP,
          type: PieceType.SPATIAL,
          shape: PieceShape.L,
          location: PieceLocation.SPATIAL_BOARD,
        ),
        row: 1,
        col: 3
    );
    spatialManager.addPieceToTargetBoard(
        piece: Piece.withDetails(
          rotation: PieceRotation.DOWN,
          type: PieceType.SPATIAL,
          shape: PieceShape.L,
          location: PieceLocation.SPATIAL_BOARD,
        ),
        row: 3,
        col: 1
    );
    spatialManager.addPieceToTargetBoard(
        piece: Piece.withDetails(
          rotation: PieceRotation.RIGHT,
          type: PieceType.SPATIAL,
          shape: PieceShape.L,
          location: PieceLocation.SPATIAL_BOARD,
        ),
        row: 3,
        col: 3
    );
  }

  @override
  void createSpatialLevelThree({required SpatialManager spatialManager}) {
    spatialManager.addPieceToTargetBoard(
        piece: Piece.withDetails(
          rotation: PieceRotation.LEFT,
          type: PieceType.SPATIAL,
          shape: PieceShape.LINE,
          location: PieceLocation.SPATIAL_BOARD,
        ),
        row: 1,
        col: 0
    );
    spatialManager.addPieceToTargetBoard(
        piece: Piece.withDetails(
          rotation: PieceRotation.LEFT,
          type: PieceType.SPATIAL,
          shape: PieceShape.LINE,
          location: PieceLocation.SPATIAL_BOARD,
        ),
        row: 3,
        col: 0
    );
    spatialManager.addPieceToTargetBoard(
        piece: Piece.withDetails(
          rotation: PieceRotation.LEFT,
          type: PieceType.SPATIAL,
          shape: PieceShape.LINE,
          location: PieceLocation.SPATIAL_BOARD,
        ),
        row: 1,
        col: 5
    );
    spatialManager.addPieceToTargetBoard(
        piece: Piece.withDetails(
          rotation: PieceRotation.LEFT,
          type: PieceType.SPATIAL,
          shape: PieceShape.LINE,
          location: PieceLocation.SPATIAL_BOARD,
        ),
        row: 3,
        col: 5
    );
    spatialManager.addPieceToTargetBoard(
        piece: Piece.withDetails(
          rotation: PieceRotation.LEFT,
          type: PieceType.SPATIAL,
          shape: PieceShape.L,
          location: PieceLocation.SPATIAL_BOARD,
        ),
        row: 1,
        col: 1
    );
    spatialManager.addPieceToTargetBoard(
        piece: Piece.withDetails(
          rotation: PieceRotation.DOWN,
          type: PieceType.SPATIAL,
          shape: PieceShape.L,
          location: PieceLocation.SPATIAL_BOARD,
        ),
        row: 3,
        col: 1
    );
    spatialManager.addPieceToTargetBoard(
        piece: Piece.withDetails(
          rotation: PieceRotation.UP,
          type: PieceType.SPATIAL,
          shape: PieceShape.L,
          location: PieceLocation.SPATIAL_BOARD,
        ),
        row: 0,
        col: 3
    );
    spatialManager.addPieceToTargetBoard(
        piece: Piece.withDetails(
          rotation: PieceRotation.RIGHT,
          type: PieceType.SPATIAL,
          shape: PieceShape.L,
          location: PieceLocation.SPATIAL_BOARD,
        ),
        row: 4,
        col: 3
    );
  }

  @override
  void createSpatialLevelTwo({required SpatialManager spatialManager}) {
    spatialManager.addPieceToTargetBoard(
        piece: Piece.withDetails(
          rotation: PieceRotation.LEFT,
          type: PieceType.SPATIAL,
          shape: PieceShape.SQUARE,
          location: PieceLocation.SPATIAL_BOARD,
        ),
        row: 1,
        col: 1
    );
    spatialManager.addPieceToTargetBoard(
        piece: Piece.withDetails(
          rotation: PieceRotation.UP,
          type: PieceType.SPATIAL,
          shape: PieceShape.SQUARE,
          location: PieceLocation.SPATIAL_BOARD,
        ),
        row: 3,
        col: 3
    );
    spatialManager.addPieceToTargetBoard(
        piece: Piece.withDetails(
          rotation: PieceRotation.DOWN,
          type: PieceType.SPATIAL,
          shape: PieceShape.DOT,
          location: PieceLocation.SPATIAL_BOARD,
        ),
        row: 3,
        col: 1
    );
    spatialManager.addPieceToTargetBoard(
        piece: Piece.withDetails(
          rotation: PieceRotation.RIGHT,
          type: PieceType.SPATIAL,
          shape: PieceShape.DOT,
          location: PieceLocation.SPATIAL_BOARD,
        ),
        row: 4,
        col: 2
    );
    spatialManager.addPieceToTargetBoard(
        piece: Piece.withDetails(
          rotation: PieceRotation.RIGHT,
          type: PieceType.SPATIAL,
          shape: PieceShape.DOT,
          location: PieceLocation.SPATIAL_BOARD,
        ),
        row: 2,
        col: 3
    );
  }

  @override
  List<Piece> removeAllPieces() {
    List<Piece> lista = [];

    for (int row = 0; row < 6; row++) {
      for (int col = 0; col < 6; col++) {
        Piece curr = getBasePiece(row: row, col: col);

        if (!curr.isNullPiece) {
          lista.add(
              removePiece(piece: curr)
          );
        }
      }
    }

    return lista;
  }
}