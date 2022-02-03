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

// Utils
import 'package:flutter_slide_competition/prototype/ui/utils/pretty_text.dart';

class PostPuzzleScreen extends StatelessWidget {
  late final PuzzleFetchUseCase puzzleFetchUseCase;
  late final LevelManagementUseCases levelManagementUseCases;

  PostPuzzleScreen({
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
    return Consumer<NavigationManager>(
      builder: (_, navigationManager, __) {
        return SingleChildScrollView(
          child: Column(children: [
            // Texto con sombra
            PrettyText(
              "Congratulations! You have finished exploring the mansion and uncovered all of its secrets. Will you tell the world about them?\n\nINFO ADICIONAL - esta pantalla solo aparece después del room 5, necesitan las demás su propia pantalla POST, aparte de la PRE que aparece antes de cada room?",
            ),

            // Espaciador
            const SizedBox(
              height: 20,
            ),

            // Botón para finalizar
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).popAndPushNamed('/end');
              },
              child: const Text("END GAME",
                  style: TextStyle(
                    fontSize: 24,
                  )),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            )
          ]),
        );
      },
    );
  }
}
