// Contracts
import 'package:flutter_slide_competition/dev/data/models/sound.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/puzzle_selection_contract.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/level_manager.dart';
import 'package:flutter_slide_competition/dev/data/models/puzzle.dart';

class PuzzleRepositoryImpl implements PuzzleRepository {
  PuzzleRepositoryImpl();

  @override
  Puzzle fetchPuzzle(
      {required PuzzleType puzzleType, required PuzzleLevel puzzleLevel}) {
    // Creates an Puzzle matching the type of the requested puzzle
    if (puzzleType == PuzzleType.SOUND) {
      switch (puzzleLevel) {
        case PuzzleLevel.LV1:
        case PuzzleLevel.LV2:
          return AuditivePuzzle(
              soundType: SoundType.NOTES, puzzleLevel: puzzleLevel);
        case PuzzleLevel.LV3:
          return AuditivePuzzle(
              soundType: SoundType.CHORD, puzzleLevel: puzzleLevel);
      }
    } else if (puzzleType == PuzzleType.SPATIAL) {
      return SpatialPuzzle(puzzleLevel: puzzleLevel);
    } else
      throw Exception('PuzzleRepositoryImpl: Unkown puzzle type detected');
  }
}
