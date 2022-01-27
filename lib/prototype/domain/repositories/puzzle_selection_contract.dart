// Models
import 'package:flutter_slide_competition/prototype/data/models/level_manager.dart';
import 'package:flutter_slide_competition/prototype/data/models/puzzle.dart';

abstract class PuzzleRepository {
  Future<Puzzle> fetchPuzzle(PuzzleType puzzleType);
}
