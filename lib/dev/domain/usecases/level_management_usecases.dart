// Models
import 'package:flutter_slide_competition/dev/data/models/level_manager.dart';
import '../../data/models/puzzle.dart';

// Repositories
import 'package:flutter_slide_competition/dev/domain/repositories/level_management_contract.dart';

class LevelManagementUseCases {
  final LevelManagementRepository levelManagementRepository;

  LevelManagementUseCases({required this.levelManagementRepository});

  Future<PuzzleType> getForcedPuzzleType() async {
    return this.levelManagementRepository.obtainForcedPuzzle();
  }

  PuzzleType getForcedPuzzleTypeNonFuture() {
    return this.levelManagementRepository.obtainForcedPuzzleNonFuture();
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

  // Obtener cuando niveles se han completado
  Future<int> getCompletedLevels() async {
    return this.levelManagementRepository.totalCompletedLevels();
  }

  int getCompletedLevelsNonFuture() {
    return this.levelManagementRepository.totalCompletedLevelsNonFuture();
  }

  void increaseCounter({required PuzzleType puzzleType}) async {
    this
        .levelManagementRepository
        .increasePuzzleCounter(puzzleType: puzzleType);
  }

  void updatePreviousPuzzle({required PuzzleType puzzleType}) {
    this.levelManagementRepository.setPreviousPuzzle(puzzleType: puzzleType);
  }

  PuzzleLevel getCurrentPuzzleLevel({required PuzzleType puzzleType}) {
    return this
        .levelManagementRepository
        .getPuzzleLevel(puzzleType: puzzleType);
  }

  // Valor temporal que será usado por la pantalla PRE
  void updateTempType({required PuzzleType puzzleType}) {
    this.levelManagementRepository.setTempType(puzzleType: puzzleType);
  }

  PuzzleType getTempType() {
    return this.levelManagementRepository.getTempType();
  }
}
