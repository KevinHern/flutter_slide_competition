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
                  child: Image.asset('assets/guitar.jpg'),
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
                  child: Image.asset('assets/statue.jpg'),
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
