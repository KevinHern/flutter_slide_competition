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
import 'package:provider/provider.dart';

// Utils
import 'package:flutter_slide_competition/dev/ui/utils/pretty_text.dart';

class PostPuzzleScreen extends StatelessWidget {
  late final PuzzleFetchUseCase puzzleFetchUseCase;
  late final LevelManagementUseCases levelManagementUseCases;

  static const List<String> textsDone = [
    """
    Congratulations! You have finished exploring the mansion and uncovered all of its secrets.
    
    It took a really long time to set them all up, but it was all worth it.
    
    Will you tell the world about the mansion? If so, I will prepare some more puzzles!
    """,
    """
    Wow! You solved everything that this mansion had in store!
    
    Aren't you excited to tell somebody else? Please do!
    
    I want to play some more, so I'll start preparing more puzzles for the next visitors!
    """,
    """
    You for sure are gifted at solving mysteries. All the secrets of the mansion seem to be uncovered!
    
    Will you let everyone else know about the mysteries?
    
    Tell everyone and bring your friends! I will prepare some more puzzles in the meantime.
    """,
    """
    What an amazing job you have done! There are no mysteries safe from you, hehehe.
    
    What are you going to do next? Tell everyone about your experience?
    
    Please do, and bring many friends! I want everyone to know about my puzzles!
    """
  ];

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
              'A very friendly ghostly voice: ' + textsDone[Random().nextInt(textsDone.length)],
              fontFamily: Theme.of(context).textTheme.subtitle1!.fontFamily,
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
              child: AwesomeText(
                "END GAME",
                fontFamily: Theme.of(context).textTheme.headline1!.fontFamily,
              ),
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
