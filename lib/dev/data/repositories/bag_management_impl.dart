// Models
import 'package:flutter_slide_competition/dev/data/models/bag.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

// Contracts
import 'package:flutter_slide_competition/dev/domain/repositories/bag_management_contract.dart';

class BagManagementRepositoryImpl implements BagManagementRepository {
  late final Bag _bag;
  BagManagementRepositoryImpl({required Bag bag}) {
    this._bag = bag;
  }

  @override
  void addPiece({required Piece puzzlePiece}) {
    this._bag.addPiece(puzzlePiece: puzzlePiece);
  }

  @override
  bool removePiece({required Piece piece}) =>
      this._bag.erasePiece(puzzlePiece: piece);

  @override
  void rotatePiece(
      {required Piece puzzlePiece, required PieceRotation newRotation}) {
    puzzlePiece.rotation = newRotation;
  }
}
