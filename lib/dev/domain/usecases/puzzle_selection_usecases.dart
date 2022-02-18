import 'dart:async';

import 'package:flutter_slide_competition/dev/data/models/level_manager.dart';
import 'package:flutter_slide_competition/dev/data/models/puzzle.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/puzzle_selection_contract.dart';

class PuzzleFetchUseCase {
  final PuzzleRepository puzzleRepository;

  PuzzleFetchUseCase({required this.puzzleRepository});

  Future<Puzzle> fetchPuzzle(
      {required PuzzleType puzzleType,
      required PuzzleLevel puzzleLevel}) async {
    return this
        .puzzleRepository
        .fetchPuzzle(puzzleType: puzzleType, puzzleLevel: puzzleLevel);
  }
}
