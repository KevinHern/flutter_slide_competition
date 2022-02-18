// Models
import 'package:flutter_slide_competition/dev/data/models/level_manager.dart';
import 'package:flutter_slide_competition/dev/data/models/puzzle.dart';

abstract class PuzzleRepository {
  Puzzle fetchPuzzle(
      {required PuzzleType puzzleType, required PuzzleLevel puzzleLevel});
}
