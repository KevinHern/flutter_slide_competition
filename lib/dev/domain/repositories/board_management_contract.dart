// Models
import 'package:flutter_slide_competition/dev/data/models/board.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

abstract class BoardManagementRepository {
  void createAudioLevelOne ();
  void createAudioLevelTwo ();
  void createAudioLevelThree ();
  void createSpatialLevelOne ();
  void createSpatialLevelTwo ();
  void createSpatialLevelThree ();
  // instanciar board
  // colocar manualmente Piece
  // exit

  // field Board

  bool movePiece ({required BoardDirection direction, required Piece piece});
  bool checkCollision ({required BoardDirection direction, required Piece piece});
  void moveReferencesOnBoard ({required BoardDirection direction, required Piece piece});
  bool checkExit ({required Piece piece});
  void pieceCleanup ({required Piece piece});
}