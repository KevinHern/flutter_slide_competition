// Models
import 'package:flutter_slide_competition/dev/data/models/board.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

abstract class BoardManagementRepository {
  void createAudioLevelOne ({required board});
  void createAudioLevelTwo ({required board});
  void createAudioLevelThree ({required board});
  void createSpatialLevelOne ({required board});
  void createSpatialLevelTwo ({required board});
  void createSpatialLevelThree ({required board});

  Piece movePiece ({required BoardDirection direction, required Piece piece});
  bool checkCollision ({required BoardDirection direction, required Piece piece});
  void moveReferencesOnBoard ({required BoardDirection direction, required Piece piece});
  bool checkExit ({required Piece piece});
  void pieceCleanup ({required Piece piece});

  Piece getBasePiece ({required int row, required int col});
}
