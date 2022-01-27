// Basic Imports
import 'package:flutter/material.dart';

// Models
import 'package:flutter_slide_competition/prototype/data/models/level_manager.dart';

// Repositories
import 'package:flutter_slide_competition/prototype/domain/repositories/level_management_contract.dart';
import 'package:flutter_slide_competition/prototype/domain/repositories/puzzle_selection_contract.dart';

// Use Cases
import 'package:flutter_slide_competition/prototype/domain/usecases/level_management_usecases.dart';
import 'package:flutter_slide_competition/prototype/domain/usecases/puzzle_selection_usecases.dart';

// State Management
import 'package:flutter_slide_competition/prototype/ui/models/screen_manager.dart';
import 'package:provider/provider.dart';

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
    // Get the puzzle itself
    navigationManager.setPuzzle =
        await this.puzzleFetchUseCase.fetchPuzzle(puzzleType: puzzleType);

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
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _fetchThisPuzzle(
                  navigationManager: navigationManager,
                  puzzleType: PuzzleType.SOUND),
              child: Text('Sound Puzzle'),
              style: ElevatedButton.styleFrom(),
            ),
            ElevatedButton(
              onPressed: () => _fetchThisPuzzle(
                  navigationManager: navigationManager,
                  puzzleType: PuzzleType.SPATIAL),
              child: Text('Spatial Puzzle'),
              style: ElevatedButton.styleFrom(),
            ),
          ],
        );
      },
    );
  }
}
