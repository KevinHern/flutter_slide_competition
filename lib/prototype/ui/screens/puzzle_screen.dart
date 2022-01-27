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
      color: Colors.blueGrey,
      child: Center(
        child: ChangeNotifierProvider<ValueNotifier<int>>(
          create: (context) => ValueNotifier(1),
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
      child: Text(
        'Room #' +
            Provider.of<ValueNotifier<int>>(context, listen: true)
                .value
                .toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 36,
        ),
      ),
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
