// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

abstract class SpatialManagementRepository {
  bool compareBoards ();
  int checkEmptySpace ();

  bool addPiece ({required Piece piece, required int row, required int col});
  bool movePiece ({required Piece piece, required int row, required int col});
  Piece removePiece ({required Piece piece});

  Piece getBasePiece ({required int row, required int col});

}

