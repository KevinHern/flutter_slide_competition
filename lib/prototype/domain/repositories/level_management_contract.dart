import 'package:flutter_slide_competition/prototype/data/models/level_manager.dart';

abstract class LevelManagementRepository {
  Future<bool> isForced({required PuzzleType currentPuzzle});
  Future<PuzzleType> obtainForcedPuzzle();
  Future<int> totalCompletedLevels();
  void increasePuzzleCounter({required PuzzleType puzzleType});
  void setPreviousPuzzle({required PuzzleType puzzleType});
}
