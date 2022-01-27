import 'package:flutter_slide_competition/prototype/data/models/level_manager.dart';
import 'package:flutter_slide_competition/prototype/domain/repositories/level_management_contract.dart';

class LevelManagementUseCases {
  final LevelManagementRepository levelManagementRepository;

  LevelManagementUseCases({required this.levelManagementRepository});

  Future<PuzzleType> getForcedPuzzleType() async {
    return this.levelManagementRepository.obtainForcedPuzzle();
  }

  Future<bool> isNextLevelForcedPuzzle(
      {required PuzzleType currentPuzzle}) async {
    return this
        .levelManagementRepository
        .isForced(currentPuzzle: currentPuzzle);
  }

  Future<bool> isGameComplete() async {
    int totalLevels =
        await this.levelManagementRepository.totalCompletedLevels();
    bool result = totalLevels == 5;
    return result;
  }

  void increaseCounter({required PuzzleType puzzleType}) async {
    this
        .levelManagementRepository
        .increasePuzzleCounter(puzzleType: puzzleType);
  }

  void updatePreviousPuzzle({required PuzzleType puzzleType}) {
    this.levelManagementRepository.setPreviousPuzzle(puzzleType: puzzleType);
  }
}
