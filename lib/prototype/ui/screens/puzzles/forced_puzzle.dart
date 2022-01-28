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

class ForcedPuzzleScreen extends StatelessWidget {
  late final PuzzleFetchUseCase puzzleFetchUseCase;
  late final LevelManagementUseCases levelManagementUseCases;

  ForcedPuzzleScreen({
    required PuzzleRepository puzzleRepository,
    required LevelManagementRepository levelManagementRepository,
    Key? key,
  }) : super(key: key) {
    this.puzzleFetchUseCase =
        PuzzleFetchUseCase(puzzleRepository: puzzleRepository);
    this.levelManagementUseCases = LevelManagementUseCases(
        levelManagementRepository: levelManagementRepository);
  }

  @override
  Widget build(BuildContext context) {
    PuzzleType tipo = this.levelManagementUseCases.getForcedPuzzleTypeNonFuture();

    return Consumer<NavigationManager>(
      builder: (_, navigationManager, __) {
        return ElevatedButton(
          onPressed: () async {
            // Obtain the forced Puzzle
            PuzzleType forcedPuzzleType =
                await this.levelManagementUseCases.getForcedPuzzleType();

            // Set the puzzle to solve
            navigationManager.setPuzzle = await this
                .puzzleFetchUseCase
                .fetchPuzzle(puzzleType: forcedPuzzleType);

            // Set the screen to the respective puzzle
            navigationManager.setCurrentScreen =
                (forcedPuzzleType == PuzzleType.SOUND)
                    ? ScreenType.AUDITIVE_PUZZLE
                    : ScreenType.SPATIAL_PUZZLE;

            // Update Puzzle counter
            levelManagementUseCases.increaseCounter(
                puzzleType: forcedPuzzleType);

            // Update Previous Puzzle
            this.levelManagementUseCases
                .updatePreviousPuzzle(puzzleType: forcedPuzzleType);

            // Update UI
            navigationManager.update();
          },
          child: Image.asset(
              (tipo == PuzzleType.SOUND) ? 'assets/guitar.jpg' : 'assets/statue.jpg',
              width: 200,
              height: 300,
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          ),
        );
      },
    );
  }
}
