// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

abstract class BagManagementRepository {
  void addPiece({required Piece puzzlePiece});
  bool removePiece({required Piece piece});
  void rotatePiece(
      {required Piece puzzlePiece, required PieceRotation newRotation});
}
