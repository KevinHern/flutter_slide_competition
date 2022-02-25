// Basic Imports
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/level_manager.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/puzzle.dart';
import 'package:flutter_slide_competition/dev/ui/models/screen_manager.dart';
import 'package:flutter_slide_competition/dev/data/models/board.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

// Repositories (contracts)
import 'package:flutter_slide_competition/dev/domain/repositories/level_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/bag_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/board_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/sound_management_contract.dart';

// Repositories (implementations)
import 'package:flutter_slide_competition/dev/data/repositories/bag_management_impl.dart';
import 'package:flutter_slide_competition/dev/data/repositories/board_management_impl.dart';
import 'package:flutter_slide_competition/dev/data/repositories/selected_piece_management_impl.dart';
import 'package:flutter_slide_competition/dev/data/repositories/sound_management_impl.dart';

// Use Cases
import 'package:flutter_slide_competition/dev/domain/usecases/level_management_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/board_grid_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/bag_management_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/dpad_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/selected_piece_usecases.dart';

// State Management
import 'package:provider/provider.dart';

// UI
import 'package:flutter_slide_competition/dev/ui/utils/pretty_text.dart';

// UI Provider Models
import 'package:flutter_slide_competition/dev/ui/models/bagUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/boardUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_board_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/sound_slotUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/toggle_managerUI.dart';

// Extra Widgets
import '../../../../dev/ui/utils/my_utils.dart';
import '../../models/hint_managerUI.dart';
import 'components/bag_widget.dart';
import 'components/board_grid.dart';
import 'components/dpad.dart';
import 'components/sound_game.dart';

class AuditivePuzzleWidget extends StatelessWidget {
  // Models
  final AuditivePuzzle puzzle;

  // Repositories
  late final BoardManagementRepository boardManagementRepository;
  late final BagManagementRepository bagManagementRepository;
  late final SelectedPieceManagementRepository
  selectedPieceManagementRepository;
  late final SoundManagementRepository soundManagementRepository;

  // Use Cases
  late final LevelManagementUseCases levelManagementUseCases;

  AuditivePuzzleWidget({
    required this.puzzle,
    required LevelManagementRepository levelManagementRepository,
    Key? key,
  }) : super(key: key) {
    // Repositories Initialization
    selectedPieceManagementRepository = PieceManagementRepositoryImpl(
        selectedPieceManager: this.puzzle.selectedPieceManager);

    bagManagementRepository =
        BagManagementRepositoryImpl(bag: this.puzzle.bagOfPieces);

    boardManagementRepository =
        BoardManagementRepositoryImpl(board: this.puzzle.puzzleSlidingBoard);

    soundManagementRepository =
        SoundManagementRepositoryImpl(soundManager: this.puzzle.soundManager);

    // Use Cases Initialization
    this.levelManagementUseCases = LevelManagementUseCases(
        levelManagementRepository: levelManagementRepository);

    // Board Initialization
    BoardGridUseCases(boardManagementRepository: this.boardManagementRepository)
        .initializeSlidingBoard(
      board: this.puzzle.puzzleSlidingBoard,
      puzzleType: PuzzleType.SOUND,
      puzzleLevel: this.puzzle.puzzleLevel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AllProviders(
        puzzle: this.puzzle,
        child: Column(
          children: [
            Card(
              color: Colors.white.withOpacity(0.50),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: AuditivePuzzleBody(
                    selectedPieceManagementRepository:
                    this.selectedPieceManagementRepository,
                    boardManagementRepository: this.boardManagementRepository,
                    bagManagementRepository: this.bagManagementRepository,
                    soundManagementRepository: this.soundManagementRepository,
                    levelManagementUseCases: this.levelManagementUseCases,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllProviders extends StatelessWidget {
  final AuditivePuzzle puzzle;
  final Widget child;

  const AllProviders({required this.puzzle, required this.child, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BoardUI>(
            create: (context) =>
                BoardUI(board: this.puzzle.puzzleSlidingBoard)),
        ChangeNotifierProvider<BagUI>(
          create: (context) => BagUI(bag: this.puzzle.bagOfPieces),
        ),
        ChangeNotifierProvider<BoardPieceManagerUI>(
          create: (context) => BoardPieceManagerUI(),
        ),
        ChangeNotifierProvider<SelectedPieceManagerUI>(
          create: (context) => SelectedPieceManagerUI(),
        ),
        ChangeNotifierProvider<ToggleRotation>(
          create: (context) => ToggleRotation(canRotate: true),
        ),
        ChangeNotifierProvider<SoundSlotUI>(
          create: (context) => SoundSlotUI(sound: this.puzzle.soundManager),
        ),
        ChangeNotifierProvider<UniversalPuzzleToggleManager>(
          create: (context) => UniversalPuzzleToggleManager(),
        ),
      ],
      child: child,
    );
  }
}

class AuditivePuzzleBody extends StatelessWidget {
  final SelectedPieceManagementRepository selectedPieceManagementRepository;
  final BoardManagementRepository boardManagementRepository;
  final BagManagementRepository bagManagementRepository;
  final SoundManagementRepository soundManagementRepository;
  final LevelManagementUseCases levelManagementUseCases;

  const AuditivePuzzleBody(
      {required this.selectedPieceManagementRepository,
        required this.boardManagementRepository,
        required this.bagManagementRepository,
        required this.soundManagementRepository,
        required this.levelManagementUseCases,
        Key? key})
      : super(key: key);

  void _move(
      {required BuildContext context,
        required BoardDirection direction}) async {
    final Piece piece = SelectedPieceManagementUseCases(
        selectedPieceManagementRepository:
        selectedPieceManagementRepository)
        .getCurrentSelectedPiece();

    if (piece.isNullPiece) return;

    final Piece outPiece =
    DpadUseCases(boardManagementRepository: boardManagementRepository)
        .movePiece(direction: direction, puzzlePiece: piece);

    Provider.of<BoardUI>(context, listen: false).update();

    if (!outPiece.isNullPiece) {
      BagManagementUseCases(bagManagementRepository: bagManagementRepository)
          .addToBag(puzzlePiece: outPiece);

      Provider.of<BagUI>(context, listen: false).update();

      Provider.of<ToggleRotation>(context, listen: false).canRotate = true;
      Provider.of<SelectedPieceManagerUI>(context, listen: false)
          .selectedPiece = outPiece;

      if (Provider.of<HintManager>(context, listen: false)
          .showChangeToBagHint) {
        await MyUtils.showMessage(
          context: context,
          title: 'Hint!',
          message:
          'Good going! All the pieces you take out from the sliding puzzle are placed in a special bag you have.\n'
              'Try clicking the orange button that says \'Change to Bag\' and check all the available pieces you have!\n\n'
              'After that, click one of those pieces.',
          onPressed: () {
            Provider.of<HintManager>(context, listen: false)
                .showChangeToBagHint = false;
            // Muestra animacion indicando que debe ir a la bolsa
            Provider.of<HintManager>(context, listen: false)
                .showClickOnChangeButton = true;
            Provider.of<HintManager>(context, listen: false).update();
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration.zero,
          () async {
        if (Provider.of<HintManager>(context, listen: false)
            .showMovePieceHint) {
          await MyUtils.showMessage(
            context: context,
            title: 'Hint!',
            message:
            'Click a piece on the sliding board (left) and try to move it using the Dpad found below.\n'
                'Try to take the piece out by moving it towards the squares that are painted differently!\n\n'
                'Take into consideration that there are movable pieces, dummy pieces and fixed pieces.\n'
                'The first 2 can be moved anywhere within the board but the dummy pieces can\'t be taken out form the board.\n'
                'While the fixed pieces are pieces that are immovable at all!',
            onPressed: () => Provider.of<HintManager>(context, listen: false)
                .showMovePieceHint = false,
          );
        }
      },
    );

    return Provider.of<UniversalPuzzleToggleManager>(context, listen: true)
        .canShowWinButtonActive
        ? FinishButton(levelManagementUseCases: this.levelManagementUseCases)
        : SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Consumer<UniversalPuzzleToggleManager>(
                builder: (_, universalPuzzleToggleManager, __) {
                  return Stack(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          universalPuzzleToggleManager.showBag =
                          !universalPuzzleToggleManager.canShowBag;
                          // Inicialmente no muestra animacion
                          Provider.of<HintManager>(context, listen: false)
                              .showClickOnChangeButton = false;
                          Provider.of<HintManager>(context, listen: false)
                              .update();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          padding: const EdgeInsets.all(10.0),
                          primary: const Color(0xFFFFC09F),
                          onPrimary: const Color(0xFFFCF5C7),
                          shadowColor: const Color(0xFFFFC09F),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Change to ' +
                                  ((universalPuzzleToggleManager
                                      .canShowBag)
                                      ? 'bag'
                                      : 'board'),
                              style:
                              Theme.of(context).textTheme.subtitle1,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Image.asset(
                              'icons/shift.png',
                              scale: 3,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 50,
                        child: Visibility(
                          // Visibilidad de la animacion controlada por el provider
                          visible: Provider.of<HintManager>(context,
                              listen: true)
                              .showClickOnChangeButton,
                          child: Image.asset(
                            'assets/click.gif',
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              (Provider.of<UniversalPuzzleToggleManager>(context,
                  listen: true)
                  .canShowBag)
                  ? Column(
                children: [
                  Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BoardGrid(
                        board: Provider.of<BoardUI>(context,
                            listen: true)
                            .board,
                        selectedManager:
                        selectedPieceManagementRepository,
                        soundManagementRepository:
                        this.soundManagementRepository,
                        boardType: BoardType.SOUND,
                        moveUp: () => _move(
                            context: context,
                            direction: BoardDirection.UP),
                        moveRight: () => _move(
                            context: context,
                            direction: BoardDirection.RIGHT),
                        moveDown: () => _move(
                            context: context,
                            direction: BoardDirection.DOWN),
                        moveLeft: () => _move(
                            context: context,
                            direction: BoardDirection.LEFT),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DPad(
                    scale: 1.5,
                    isActive: true,
                    upPress: () => _move(
                        context: context,
                        direction: BoardDirection.UP),
                    rightPress: () => _move(
                        context: context,
                        direction: BoardDirection.RIGHT),
                    downPress: () => _move(
                        context: context,
                        direction: BoardDirection.DOWN),
                    leftPress: () => _move(
                        context: context,
                        direction: BoardDirection.LEFT),
                  ),
                ],
              )
                  : BagWidget(
                bagOfPieces:
                Provider.of<BagUI>(context, listen: true).bag,
                toggleRotation: Provider.of<ToggleRotation>(context,
                    listen: true),
                height: 500,
                width: 550,
                selectedPieceManagementRepository:
                selectedPieceManagementRepository,
                soundManagementRepository:
                this.soundManagementRepository,
                bagType: BagType.SOUND,
              ),
            ],
          ),
          const SizedBox(
            width: 50,
          ),
          SoundGameWidget(
            soundSlotWidth: 600,
            soundManagementRepository: soundManagementRepository,
            bagManagementRepository: bagManagementRepository,
            selectedPieceManagementRepository:
            selectedPieceManagementRepository,
          ),
        ],
      ),
    );
  }
}

class FinishButton extends StatelessWidget {
  final LevelManagementUseCases levelManagementUseCases;
  const FinishButton({required this.levelManagementUseCases, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationManager>(
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
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
                  .updatePreviousPuzzle(puzzleType: PuzzleType.SOUND);

              // Guarda un valor temporal que será usado por la pantalla PRE
              this
                  .levelManagementUseCases
                  .updateTempType(puzzleType: PuzzleType.SOUND);

              // Update UI
              navigationManager.update();
              Provider.of<ValueNotifier<int>>(context, listen: false).value++;
            }
          },
        );
      },
    );
  }
}
