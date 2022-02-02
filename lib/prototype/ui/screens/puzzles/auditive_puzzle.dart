// Basic Imports
import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/prototype/data/models/level_manager.dart';

// Models
import 'package:flutter_slide_competition/prototype/data/models/puzzle.dart';
import 'package:flutter_slide_competition/prototype/ui/models/screen_manager.dart';

// Repositories
import 'package:flutter_slide_competition/prototype/domain/repositories/level_management_contract.dart';

// Use Cases
import 'package:flutter_slide_competition/prototype/domain/usecases/level_management_usecases.dart';

// State Management
import 'package:provider/provider.dart';

class AuditivePuzzleWidget extends StatelessWidget {
  final AuditivePuzzle puzzle;

  // Use Cases
  late final LevelManagementUseCases levelManagementUseCases;

  AuditivePuzzleWidget({
    required this.puzzle,
    required LevelManagementRepository levelManagementRepository,
    Key? key,
  }) : super(key: key) {
    this.levelManagementUseCases = LevelManagementUseCases(
        levelManagementRepository: levelManagementRepository);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.lightBlueAccent,
          child: Image.asset(
              'assets/puzzle_sound.png'
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Consumer<NavigationManager>(
          builder: (_, navigationManager, __) {
            return ElevatedButton(
              child: Text("Next Level!"),
              onPressed: () async {
                // Check if they already completed 5 puzzles
                if (await levelManagementUseCases.isGameComplete()) {
                  // Jump to End Screen
                  Navigator.of(context).popAndPushNamed('/end');
                } else {
                  navigationManager.setCurrentScreen = ScreenType.PRE_PUZZLE;

                  // Obtain puzzle
                  navigationManager.setPuzzle = Puzzle();

                  // Update Previous Puzzle
                  this
                      .levelManagementUseCases
                      .updatePreviousPuzzle(puzzleType: PuzzleType.SOUND);

                  // Guarda un valor temporal que será usado por la pantalla PRE
                  this.levelManagementUseCases.updateTempType(puzzleType: PuzzleType.SOUND);

                  // Update UI
                  navigationManager.update();
                  Provider.of<ValueNotifier<int>>(context, listen: false)
                      .value++;
                }
              },
            );
          },
        ),
      ],
    );
  }
}
