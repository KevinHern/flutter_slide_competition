// Basic Imports
import 'package:flutter/material.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/level_manager.dart';
import 'package:flutter_slide_competition/dev/data/models/puzzle.dart';

// Repositories
import 'package:flutter_slide_competition/dev/domain/repositories/level_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/puzzle_selection_contract.dart';
import 'package:flutter_slide_competition/dev/data/repositories/level_management_impl.dart';
import 'package:flutter_slide_competition/dev/data/repositories/puzzle_selection_impl.dart';
import 'package:flutter_slide_competition/dev/ui/models/hint_managerUI.dart';

// Screens
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/auditive_puzzle.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/forced_puzzle.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/select_puzzle.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/spatial_puzzle.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/pre_puzzle.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/post_puzzle.dart';

// State Management
import 'package:flutter_slide_competition/dev/ui/models/screen_manager.dart';
import 'package:provider/provider.dart';

// Utils
import 'package:flutter_slide_competition/dev/ui/utils/my_utils.dart';
import 'package:flutter_slide_competition/dev/ui/utils/pretty_text.dart';

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
          'Journal Entry',
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

  // Container
  //   ChangeNotifierProvider
  //     Consumer
  //       Container
  //         BoxDecoration
  //           AssetImage
  //         Column
  //           PuzzleHeader
  //             SizedBox
  //               SwitchBody

  @override
  Widget build(BuildContext context) {
    // The container is the background!
    return Container(
      // Llena el espacio que se le permite
      // En PuzzleScreen se usar setScreenPadding para limitarlo
      height: double.infinity,
      width: double.infinity,
      color: Colors.transparent,

      child: ChangeNotifierProvider<ValueNotifier<int>>(
        create: (context) => ValueNotifier(1),

        // Consumer para obtener el nivel y usarlo para imagen de fondo
        child: Consumer<ValueNotifier<int>>(
          builder: (_, i, __) => Container(
            // Decoration usado para imagen de fondo
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/creepy_room' + i.value.toString() + '.jpg'),
                fit: BoxFit.cover,
              ),
            ),

            // Contenido
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Titulo del room
                  const PuzzleHeader(),

                  // SwitchBody (pre, select, forced, auditive, spatial)
                  SizedBox(
                    height: MyUtils.getSwitchBodyHeight(context: context) * 1.5,
                    child: GeneralPuzzleProviders(
                      child: SwitchBody(
                        puzzleRepository: this.puzzleRepository,
                        levelManagementRepository:
                            this.levelManagementRepository,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
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
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: PrettyText(
        'Room #' +
            Provider.of<ValueNotifier<int>>(context, listen: true)
                .value
                .toString(),
        size: 60,
        thickness: 6,
        background: Colors.transparent,
        fontFamily: Theme.of(context).textTheme.headline1!.fontFamily,
      ),
    );
  }
}

class GeneralPuzzleProviders extends StatelessWidget {
  final Widget child;

  const GeneralPuzzleProviders({required this.child, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NavigationManager>(
          create: (context) =>
              NavigationManager(currentScreen: ScreenType.PRE_PUZZLE),
        ),
        ChangeNotifierProvider<HintManager>(
          create: (context) => HintManager(),
        ),
      ],
      child: child,
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
    return Consumer<NavigationManager>(
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

          // Pantalla pre seleccion
          case ScreenType.PRE_PUZZLE:
            return PrePuzzleScreen(
              puzzleRepository: this.puzzleRepository,
              levelManagementRepository: this.levelManagementRepository,
            );

          // Pantalla post juego
          case ScreenType.POST_PUZZLE:
            return PostPuzzleScreen(
              puzzleRepository: this.puzzleRepository,
              levelManagementRepository: this.levelManagementRepository,
            );

          // Display an extra screen in case something breaks with the Navigation Manager
          default:
            return Container();
        }
      },
    );
  }
}
