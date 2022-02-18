import 'package:flutter_slide_competition/dev/data/models/level_manager.dart';

import '../../data/models/puzzle.dart';

abstract class LevelManagementRepository {
  Future<bool> isForced({required PuzzleType currentPuzzle});

  Future<PuzzleType> obtainForcedPuzzle();
  PuzzleType obtainForcedPuzzleNonFuture();

  Future<int> totalCompletedLevels();
  int totalCompletedLevelsNonFuture();

  void increasePuzzleCounter({required PuzzleType puzzleType});
  void setPreviousPuzzle({required PuzzleType puzzleType});

  PuzzleLevel getPuzzleLevel({required PuzzleType puzzleType});

  // Valor temporal que será usado por la pantalla PRE
  void setTempType({required PuzzleType puzzleType});
  PuzzleType getTempType();
}
