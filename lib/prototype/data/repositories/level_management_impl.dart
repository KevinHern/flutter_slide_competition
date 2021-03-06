import 'dart:developer';

import 'package:flutter_slide_competition/prototype/data/models/level_manager.dart';
import 'package:flutter_slide_competition/prototype/domain/repositories/level_management_contract.dart';

class LevelManagementRepositoryImpl implements LevelManagementRepository {
  late final LevelManager _levelManager;

  LevelManagementRepositoryImpl({required LevelManager levelManager}) {
    this._levelManager = levelManager;
  }

  @override
  Future<bool> isForced({required PuzzleType currentPuzzle}) {
    // Computes if the next puzzle is a game imposed puzzle
    return Future.value(
      this._levelManager.totalSound == 3 ||
          this._levelManager.totalSpatial == 3 ||
          this._levelManager.previousPuzzle == currentPuzzle,
    );
  }

  @override
  Future<PuzzleType> obtainForcedPuzzle() {
    // If we ran out of puzzles (== 3) or the previous Puzzle is the same type,
    // then return the opposite puzzle
    // todo: refactor para que quede más elegante, se eliminó bug en versión anterior
    if (this._levelManager.totalSound == 3) {
      return Future.value(PuzzleType.SPATIAL);
    } else if (this._levelManager.totalSpatial == 3) {
      return Future.value(PuzzleType.SOUND);
    } else if (this._levelManager.previousPuzzle == PuzzleType.SOUND) {
      return Future.value(PuzzleType.SPATIAL);
    } else if (this._levelManager.previousPuzzle == PuzzleType.SPATIAL) {
      return Future.value(PuzzleType.SOUND);
    } else {
      throw Exception();
    }
  }

  PuzzleType obtainForcedPuzzleNonFuture() {
    // If we ran out of puzzles (== 3) or the previous Puzzle is the same type,
    // then return the opposite puzzle
    // todo: refactor para que quede más elegante, se eliminó bug en versión anterior
    if (this._levelManager.totalSound == 3) {
      return PuzzleType.SPATIAL;
    } else if (this._levelManager.totalSpatial == 3) {
      return PuzzleType.SOUND;
    } else if (this._levelManager.previousPuzzle == PuzzleType.SOUND) {
      return PuzzleType.SPATIAL;
    } else if (this._levelManager.previousPuzzle == PuzzleType.SPATIAL) {
      return PuzzleType.SOUND;
    } else {
      throw Exception();
    }
  }

  @override
  Future<int> totalCompletedLevels() {
    // Obtains the total 'completed levels' counter
    return Future.value(this._levelManager.totalCompleted);
  }

  int totalCompletedLevelsNonFuture() {
    return this._levelManager.totalCompleted;
  }

  @override
  void increasePuzzleCounter({required PuzzleType puzzleType}) {
    // Increases both completed games and the respective puzzle counter
    this._levelManager.increaseCount(puzzleType: puzzleType);
  }

  @override
  void setPreviousPuzzle({required PuzzleType puzzleType}) {
    // Updates the previous puzzle tracking variable
    this._levelManager.previousPuzzle = puzzleType;
  }

  // Valor temporal que será usado por la pantalla PRE
  void setTempType({required PuzzleType puzzleType}) {
    this._levelManager.tempType = puzzleType;
  }
  PuzzleType getTempType() {
    return this._levelManager.tempType;
  }
}
