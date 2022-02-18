// Basic Imports
import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/level_manager.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/puzzle.dart';
import 'package:flutter_slide_competition/dev/ui/models/screen_manager.dart';

// Repositories
import 'package:flutter_slide_competition/dev/domain/repositories/level_management_contract.dart';

// Use Cases
import 'package:flutter_slide_competition/dev/domain/usecases/level_management_usecases.dart';

// State Management
import 'package:provider/provider.dart';

// UI
import 'package:flutter_slide_competition/prototype/ui/utils/pretty_text.dart';

class SpatialPuzzleWidget extends StatelessWidget {
  final SpatialPuzzle puzzle;

  // Use Cases
  late final LevelManagementUseCases levelManagementUseCases;

  SpatialPuzzleWidget({
    required this.puzzle,
    required LevelManagementRepository levelManagementRepository,
    Key? key,
  }) : super(key: key) {
    this.levelManagementUseCases = LevelManagementUseCases(
        levelManagementRepository: levelManagementRepository);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.blueGrey,
            height: 400,
            width: 600,
            child: PrettyText("Placeholder - Espacial"),
            // child: Image.asset(
            //     'assets/puzzle_sound.png'
            // ),
          ),
          const SizedBox(
            height: 15,
          ),
          Consumer<NavigationManager>(
            builder: (_, navigationManager, __) {
              return ElevatedButton(
                child: const Text(
                  "NEXT LEVEL",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () async {
                  // Check if they already completed 5 puzzles
                  if (await levelManagementUseCases.isGameComplete()) {
                    // Jump to End Screen
                    navigationManager.setCurrentScreen = ScreenType.POST_PUZZLE;
                    navigationManager.update();
                  } else {
                    navigationManager.setCurrentScreen = ScreenType.PRE_PUZZLE;

                    // Obtain puzzle
                    navigationManager.setPuzzle =
                        Puzzle(puzzleLevel: PuzzleLevel.LV1);

                    // Update Previous Puzzle
                    this
                        .levelManagementUseCases
                        .updatePreviousPuzzle(puzzleType: PuzzleType.SPATIAL);

                    // Guarda un valor temporal que será usado por la pantalla PRE
                    this
                        .levelManagementUseCases
                        .updateTempType(puzzleType: PuzzleType.SPATIAL);

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
      ),
    );
  }
}
