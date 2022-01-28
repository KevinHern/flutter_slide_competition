// Basic Imports
import 'package:flutter/material.dart';

// Models
import 'package:flutter_slide_competition/prototype/data/models/level_manager.dart';
import 'package:flutter_slide_competition/prototype/data/models/puzzle.dart';

// Repositories
import 'package:flutter_slide_competition/prototype/domain/repositories/level_management_contract.dart';
import 'package:flutter_slide_competition/prototype/domain/repositories/puzzle_selection_contract.dart';
import 'package:flutter_slide_competition/prototype/data/repositories/level_management_impl.dart';
import 'package:flutter_slide_competition/prototype/data/repositories/puzzle_selection_impl.dart';

// Screens
import 'package:flutter_slide_competition/prototype/ui/screens/puzzles/auditive_puzzle.dart';
import 'package:flutter_slide_competition/prototype/ui/screens/puzzles/forced_puzzle.dart';
import 'package:flutter_slide_competition/prototype/ui/screens/puzzles/select_puzzle.dart';
import 'package:flutter_slide_competition/prototype/ui/screens/puzzles/spatial_puzzle.dart';

// State Management
import 'package:flutter_slide_competition/prototype/ui/models/screen_manager.dart';
import 'package:provider/provider.dart';

// Utils
import 'package:flutter_slide_competition/prototype/ui/utils/my_utils.dart';

List<String> texts = [
  "",
  "A ghostly voice: Welcome! Long time since I saw a person around here, feel free to look around",
  "There is a lot to explore in this mansion!",
  "Why don't you take a look over here?",
  "You are really good at looking for clues!",
  "I feel like we are close to solve this mystery!"
];

class PuzzleScreen extends StatelessWidget {
  const PuzzleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black38,
        title: const Text(
          'The Cursed Journal Entry',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFd4d4d4),
      body: Padding(
        padding: MyUtils.setScreenPadding(context: context),
        child: Center(
          child: PuzzleBody(),
        ),
      ),
    );
  }
}

class PuzzleBody extends StatelessWidget {
  final PuzzleRepository puzzleRepository = PuzzleRepositoryImpl();
  final LevelManagementRepository levelManagementRepository =
      LevelManagementRepositoryImpl(levelManager: LevelManager());
  PuzzleBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The container is the background!
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.transparent,

      child: Center(
        child: ChangeNotifierProvider<ValueNotifier<int>>(
          create: (context) => ValueNotifier(1),
          child: Stack (
            children : [

              /* Consumer utilizado para obtener en que nivel estamos */
              /* Muestra imagen de fondo */
              Consumer<ValueNotifier<int>>(
                  builder: (_, i, __) => SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Image.asset('assets/creepy_room' + i.value.toString() + '.jpg'),
                  )
              ),

              /* Positioned usado para forzar a que se dibuje encima */
              /* Muestra titulo y contenido */
              Positioned(
                top: 150,
                width: MyUtils.getContainerWidth(context: context),
                child: Column(
                  children: [
                    const PuzzleHeader(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: Center(
                        child: SwitchBody(
                          puzzleRepository: this.puzzleRepository,
                          levelManagementRepository: this.levelManagementRepository,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]
          )
        ),
      ),
    );
  }
}

class PuzzleHeader extends StatelessWidget {
  const PuzzleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),

      child: Column (
        children: [
          Stack(
            children: [
              Text(
                'Room #' +
                    Provider.of<ValueNotifier<int>>(context, listen: true)
                        .value
                        .toString(),
                style: TextStyle(
                  fontSize: 36,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 6
                    ..color = Colors.black,
                ),
              ),
              // Solid text as fill.
              Text(
                'Room #' +
                    Provider.of<ValueNotifier<int>>(context, listen: true)
                        .value
                        .toString(),
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: <Color>[
                  Colors.black12,
                  Colors.black45,
                  Colors.black87
                ],
              ),
            ),
            child: Text(texts[Provider.of<ValueNotifier<int>>(context, listen: true).value],
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
              ),
            ),
          ),
        ]
      )
    );
  }
}

class SwitchBody extends StatelessWidget {
  final PuzzleRepository puzzleRepository;
  final LevelManagementRepository levelManagementRepository;
  const SwitchBody(
      {required this.puzzleRepository,
      required this.levelManagementRepository,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NavigationManager>(
      create: (context) =>
          NavigationManager(currentScreen: ScreenType.SELECT_PUZZLE),
      child: Consumer<NavigationManager>(
        builder: (_, navigationManager, __) {
          switch (navigationManager.getCurrentScreen) {

            // Display 'select your puzzle' screen to the player
            case ScreenType.SELECT_PUZZLE:
              return SelectPuzzleScreen(
                levelManagementRepository: this.levelManagementRepository,
                puzzleRepository: this.puzzleRepository,
              );

            // Display the screen with the NPC that tells the player to go to the other puzzle
            case ScreenType.FORCED_PUZZLE:
              return ForcedPuzzleScreen(
                levelManagementRepository: this.levelManagementRepository,
                puzzleRepository: this.puzzleRepository,
              );

            // Display the Auditive puzzle itself
            case ScreenType.AUDITIVE_PUZZLE:
              return AuditivePuzzleWidget(
                puzzle: navigationManager.getPuzzle as AuditivePuzzle,
                levelManagementRepository: this.levelManagementRepository,
              );

            // Display the Spatial Puzzle
            case ScreenType.SPATIAL_PUZZLE:
              return SpatialPuzzleWidget(
                puzzle: navigationManager.getPuzzle as SpatialPuzzle,
                levelManagementRepository: this.levelManagementRepository,
              );

            // Display an extra screen in case something breaks with the Navigation Manager
            default:
              return Container();
          }
        },
      ),
    );
  }
}
