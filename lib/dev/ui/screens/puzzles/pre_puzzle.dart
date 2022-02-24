// Basic Imports
import 'dart:math';

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

class PrePuzzleScreen extends StatelessWidget {
  late final PuzzleFetchUseCase puzzleFetchUseCase;
  late final LevelManagementUseCases levelManagementUseCases;

  // inicio del juego
  static const List<String> textsWelcome = [
    """
    Welcome! It has been a long time since I saw a the last person around here...
      
    Oh, you're investigating a mystery? I haven't seen anything unusual around here, but I'm a ghost, maybe our perceptions of 'unusual' are a little different, hehehe.
      
    Feel free to take a look around this humble mansion, I hope that you can find something that piques your curiosity, the previous owners were collectors of all things related to art.
    
    Sharpen your senses! Things might now be obvious at first, but... 
    """,
    """
    Hello hello! What do we have here?
    
    Oh!! It is another human! You may be asking why I am so excited... well, lets say I haven't had a visitor in ages!
    
    You had a reason to come here so feel free to look around. Perhaps things might be... a little interesting hehehe.
    
    I hope you figure out things, this is only the beginning!
    """,
    """
    Oh my! Is this possible? Is this a human!?
    
    Hehehe, can things become better? Of course they can! Do you think you can solve the mysteries that reside in this mansion?
    
    Well... Take your time, things are going to be fun and awesome, hehehe.
    
    Things could be out of place or can be in order... I don't know, I'll leave the rest to you...
    """
  ];

  // despues de un puzzle
  static const List<String> textsInterlude = [
    """
    You seem to love investigating as much as the owners loved their art!
    
    I didn't even notice all those things were hidden there, but you made it seem so easy, almost like solving a puzzle!
    
    There is plenty to explore in this mansion, keep on going, I think I'm gonna hang around with you...
    """,
    """
    Wow, you made it look super easy! You remind me of the owners that found anything related to art super easy to understand and interpret.
    
    I have been living here for a while and I didn't notice you could do such feats, but you showed there are more things to discover in this humble mansion.
    
    Keep it up! You are interesting, indeed, so I'll follow you for a while...
    """,
    """
    Your curiosity allowed you to discover new stuff here in the mansion! I can tell you have passion in what you do.
    
    The owners used to have that same passion over their art stuff. You for sure remind me a little of them, hehehe.
    
    I think I'll stick around for some time. What are you going to do next?
    """
  ];

  static const List<String> textsGeneric = [
    """
    You are really good at looking for clues!
    """,
    """
    You are fantastic at finding clues. Keep it up!
    """,
    """
    Solving stuff is your skill, isn't it?
    """,
    """
    Keep those solutions coming! More clues are waiting, hehehe.
    """,
    """
    Hanging out with you has been very fun! What is your next plan?
    """,
    """
    Your skills are super awesome! But... can anything stop you?
    """
  ];

  // previo a ultimo nivel
  static const List<String> textsAlmostDone = [
    """
    You are almost ready to solve this mystery!
    """,
    """
    You got this! You are near the end.
    """,
    """
    Another day, another mystery, eh? It seems you are almost done!
    """,
    """
    Wow! It seems you are about to solve this mystery!
    """,
    """
    You are so clever, but can you finish this last one?
    """
  ];

  String _getText({required int stage}) {
    switch (stage) {
      case 0:
        return textsWelcome[Random().nextInt(textsWelcome.length)];
      case 1:
        return textsInterlude[Random().nextInt(textsInterlude.length)];
      case 2:
      case 3:
        return textsGeneric[Random().nextInt(textsGeneric.length)];
      case 4:
        return textsAlmostDone[Random().nextInt(textsAlmostDone.length)];
      default:
        throw Exception(
            'Get Text at Pre Puzzle: Unknown phase of the puzzle detected.');
    }
  }

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
              'A ghostly voice: ' +
                  this._getText(
                    stage:
                        levelManagementUseCases.getCompletedLevelsNonFuture(),
                  ),
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
