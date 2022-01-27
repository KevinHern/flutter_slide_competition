// Contracts
import 'package:flutter_slide_competition/prototype/domain/repositories/puzzle_selection_contract.dart';

// Models
import 'package:flutter_slide_competition/prototype/data/models/level_manager.dart';
import 'package:flutter_slide_competition/prototype/data/models/puzzle.dart';

class PuzzleRepositoryImpl implements PuzzleRepository {
  PuzzleRepositoryImpl() {}

  @override
  Future<Puzzle> fetchPuzzle(PuzzleType puzzleType) {
    // Creates an Puzzle matching the type of the requested puzzle
    if (puzzleType == PuzzleType.SOUND) {
      return Future.value(AuditivePuzzle());
    } else if (puzzleType == PuzzleType.SPATIAL) {
      return Future.value(SpatialPuzzle());
    } else
      throw Exception();
  }
}
