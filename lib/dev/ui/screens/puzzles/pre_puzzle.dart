// Basic Imports
import 'package:flutter/material.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/level_manager.dart';

// Repositories
import 'package:flutter_slide_competition/dev/domain/repositories/level_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/puzzle_selection_contract.dart';

// Use Cases
import 'package:flutter_slide_competition/dev/domain/usecases/level_management_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/puzzle_selection_usecases.dart';

// State Management
import 'package:flutter_slide_competition/dev/ui/models/screen_manager.dart';
import 'package:flutter_slide_competition/dev/ui/utils/my_utils.dart';
import 'package:provider/provider.dart';

// Utils
import 'package:flutter_slide_competition/dev/ui/utils/pretty_text.dart';

List<String> texts = [
  """
A ghostly voice: Welcome! Long time since I saw a person around here...
  
Oh, you're investigating a mystery? I haven't seen anything unusual around here, but I'm a ghost, maybe our perceptions of 'unusual' are a little different hehehe.
  
Feel free to take a look around this humble mansion, I hope that you can find something that piques your curiosity, the previous owners were collectors of all things related to art.

Sharpen your senses! Things might now be obvious at first, but... 
""",
  """
You seem to love investigating as much as the owners loved their art!

I didn't even notice all those things were hidden there, but you made it seem so easy, almost like solving a puzzle!

There is plenty to explore in this mansion, keep on going, I think I'm gonna hang around with you...
""",
  """
You are really good at looking for clues!
""",
  """
You are really good at looking for clues!
""",
  """
You are almost ready to solve this mystery!
""",
];

class PrePuzzleScreen extends StatelessWidget {
  late final PuzzleFetchUseCase puzzleFetchUseCase;
  late final LevelManagementUseCases levelManagementUseCases;

  PrePuzzleScreen({
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
    double fontSize = MyUtils.getPrettyTextFontSize(context: context);

    return Consumer<NavigationManager>(
      builder: (_, navigationManager, __) {
        return SingleChildScrollView(
          child: Column(children: [
            // Texto con sombra
            PrettyText(
              texts[levelManagementUseCases.getCompletedLevelsNonFuture()],
              size: fontSize,
              fontFamily: Theme.of(context).textTheme.subtitle1!.fontFamily,
            ),

            // Espaciador
            SizedBox(
              height: fontSize,
            ),

            // Botón para continuar
            // ----------
            // IMPORTANTE: antes esto se hacia en AUDITIVE o SPATIAL
            // ----------
            ElevatedButton(
              onPressed: () async {
                // Después de ver la lógica, nunca se entra a este if en esta pantalla
                // Ronda #5: Pre → Puzzle (check game completion here) → Post
                /*if (await levelManagementUseCases.isGameComplete()) {
                  Navigator.of(context).popAndPushNamed('/end');
                } else {

                }*/

                // Obtener niveles completados
                int levels =
                    await this.levelManagementUseCases.getCompletedLevels();

                // Recién se está comenzando
                if (levels == 0) {
                  navigationManager.setCurrentScreen = ScreenType.SELECT_PUZZLE;

                  // Ya se jugaron niveles
                } else {
                  // Aprovechar el valor temporal que fue guardado cuando se terminó un puzzle
                  PuzzleType tempType = levelManagementUseCases.getTempType();

                  // Elegir entre SELECT o FORCED
                  bool nextLevelForced = await this
                      .levelManagementUseCases
                      .isNextLevelForcedPuzzle(currentPuzzle: tempType);

                  navigationManager.setCurrentScreen = (nextLevelForced)
                      ? ScreenType.FORCED_PUZZLE
                      : ScreenType.SELECT_PUZZLE;
                }

                // Update UI
                navigationManager.update();
              },
              child: AwesomeText(
                "CONTINUE",
                size: 25,
                fontFamily: Theme.of(context).textTheme.headline1!.fontFamily,
                horizontalPadding: 4.0,
                verticalPadding: 4.0,
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey,
                padding: EdgeInsets.symmetric(
                    horizontal: fontSize * 1.5, vertical: fontSize * 0.75),
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
