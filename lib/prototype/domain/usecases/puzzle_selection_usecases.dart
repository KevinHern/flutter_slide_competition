import 'dart:async';

import 'package:flutter_slide_competition/prototype/data/models/level_manager.dart';
import 'package:flutter_slide_competition/prototype/data/models/puzzle.dart';
import 'package:flutter_slide_competition/prototype/domain/repositories/puzzle_selection_contract.dart';

class PuzzleFetchUseCase {
  final PuzzleRepository puzzleRepository;

  PuzzleFetchUseCase({required this.puzzleRepository});

  Future<Puzzle> fetchPuzzle({required PuzzleType puzzleType}) async {
    return this.puzzleRepository.fetchPuzzle(puzzleType);
  }
}
