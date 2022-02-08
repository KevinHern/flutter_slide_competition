// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

abstract class BagManagementRepository {
  void addPiece({required Piece puzzlePiece});
  Piece removePiece({required int index});
  void rotatePiece(
      {required Piece puzzlePiece, required PieceRotation newRotation});
}
