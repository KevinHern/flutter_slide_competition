// Basic Imports
import 'dart:math';

import 'package:flutter/material.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/level_manager.dart';
import 'package:flutter_slide_competition/dev/data/models/puzzle.dart';

// Repositories
import 'package:flutter_slide_competition/dev/domain/repositories/level_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/puzzle_selection_contract.dart';

// Use Cases
import 'package:flutter_slide_competition/dev/domain/usecases/level_management_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/puzzle_selection_usecases.dart';

// State Management
import 'package:flutter_slide_competition/dev/ui/models/screen_manager.dart';
import 'package:provider/provider.dart';

import '../../../../dev/ui/utils/my_utils.dart';

class SelectPuzzleScreen extends StatelessWidget {
  late final PuzzleFetchUseCase puzzleFetchUseCase;
  late final LevelManagementUseCases levelManagementUseCases;

  SelectPuzzleScreen(
      {required PuzzleRepository puzzleRepository,
      required LevelManagementRepository levelManagementRepository,
      Key? key})
      : super(key: key) {
    this.puzzleFetchUseCase =
        PuzzleFetchUseCase(puzzleRepository: puzzleRepository);
    this.levelManagementUseCases = LevelManagementUseCases(
        levelManagementRepository: levelManagementRepository);
  }

  void _fetchThisPuzzle(
      {required NavigationManager navigationManager,
      required PuzzleType puzzleType}) async {
    // Obtain the level that the puzzle should be fetched
    PuzzleLevel currentLevel =
        levelManagementUseCases.getCurrentPuzzleLevel(puzzleType: puzzleType);

    // Get the puzzle itself
    navigationManager.setPuzzle = await this
        .puzzleFetchUseCase
        .fetchPuzzle(puzzleType: puzzleType, puzzleLevel: currentLevel);

    // Set the current screen
    navigationManager.setCurrentScreen = (puzzleType == PuzzleType.SOUND)
        ? ScreenType.AUDITIVE_PUZZLE
        : ScreenType.SPATIAL_PUZZLE;

    // Update Puzzle counter
    levelManagementUseCases.increaseCounter(puzzleType: puzzleType);

    // Update UI
    navigationManager.update();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationManager>(
      builder: (_, navigationManager, __) {
        return SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 300,
                width: 200,
                child: ElevatedButton(
                  onPressed: () => _fetchThisPuzzle(
                      navigationManager: navigationManager,
                      puzzleType: PuzzleType.SOUND),
                  child: Image.asset('assets/' +
                      MyUtils.fetchRandomImage(puzzleType: PuzzleType.SOUND) +
                      '.png'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  ),
                ),
              ),
              SizedBox(
                height: 300,
                width: 200,
                child: ElevatedButton(
                  onPressed: () => _fetchThisPuzzle(
                      navigationManager: navigationManager,
                      puzzleType: PuzzleType.SPATIAL),
                  child: Image.asset('assets/' +
                      MyUtils.fetchRandomImage(puzzleType: PuzzleType.SPATIAL) +
                      '.png'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
