// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/spatial.dart';

abstract class SpatialManagementRepository {
  bool compareBoards ();
  int checkEmptySpace ();

  bool addPiece ({required Piece piece, required int row, required int col});
  bool checkIfEmptySpace ({required Piece piece, required int row, required int col});
  Piece removePiece ({required Piece piece});

  Piece getBasePiece ({required int row, required int col});

  void createSpatialLevelOne ({required SpatialManager spatialManager});
  void createSpatialLevelTwo ({required SpatialManager spatialManager});
  void createSpatialLevelThree ({required SpatialManager spatialManager});
}

