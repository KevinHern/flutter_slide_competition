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
    print("agregando pieza");
    return false;
  }

  bool checkIfEmptySpace({required Piece piece, required int row, required int col}) {

    switch(piece.shape) {

      case PieceShape.DOT:
        return _model.userBoard[row][col].isNullPiece;
      case PieceShape.SQUARE:
        return (
          row < 7 && col < 7 &&
              _model.userBoard[row][col].isNullPiece &&
              _model.userBoard[row+1][col].isNullPiece &&
              _model.userBoard[row][col+1].isNullPiece &&
              _model.userBoard[row+1][col+1].isNullPiece
        );
      case PieceShape.LINE: {
        if (piece.rotation == PieceRotation.UP || piece.rotation == PieceRotation.DOWN) {
          // horizontal
          return (
            col < 7 &&
                _model.userBoard[row][col].isNullPiece &&
                _model.userBoard[row][col+1].isNullPiece
          );

        } else {
          // vertical
          return (
              row < 7 &&
                  _model.userBoard[row][col].isNullPiece &&
                  _model.userBoard[row+1][col].isNullPiece
          );
        }
      }
      case PieceShape.L:
        // TODO: piezas L
        break;
    }

    return false;
  }

  @override
  int checkEmptySpace() {
    int empty = 0;

    for (int row = 0; row < 6; row++) {
      for (int col = 0; col < 6; row++) {
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
      for (int col = 0; col < 6; row++) {
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
  bool movePiece({required Piece piece, required int row, required int col}) {
    // TODO: implement movePiece
    throw UnimplementedError();
  }

  @override
  Piece removePiece({required Piece piece}) {
    // TODO: implement removePiece
    throw UnimplementedError();
  }

}