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

import '../../../../dev/ui/utils/my_utils.dart';
import '../../../data/models/bag.dart';
import '../../../data/models/board.dart';
import '../../../data/models/piece.dart';
import '../../../data/models/selected_piece_manager.dart';
import '../../../data/models/sound.dart';
import '../../../data/models/spatial.dart';
import '../../../data/repositories/bag_management_impl.dart';
import '../../../data/repositories/board_management_impl.dart';
import '../../../data/repositories/selected_piece_management_impl.dart';
import '../../../data/repositories/sound_management_impl.dart';
import '../../../data/repositories/spatial_management_impl.dart';
import '../../../domain/repositories/bag_management_contract.dart';
import '../../../domain/repositories/board_management_contract.dart';
import '../../../domain/repositories/selected_piece_management_contract.dart';
import '../../../domain/repositories/sound_management_contract.dart';
import '../../../domain/repositories/spatial_management_contract.dart';
import '../../../domain/usecases/bag_management_usecases.dart';
import '../../../domain/usecases/board_grid_usecases.dart';
import '../../../domain/usecases/dpad_usecases.dart';
import '../../../domain/usecases/selected_piece_usecases.dart';
import '../../../domain/usecases/spatial_management_usecases.dart';
import '../../models/bagUI.dart';
import '../../models/boardUI.dart';
import '../../models/hint_managerUI.dart';
import '../../models/selected_board_pieceUI.dart';
import '../../models/selected_pieceUI.dart';
import '../../models/selected_spatial_pieceUI.dart';
import '../../models/spatialUI.dart';
import '../../models/toggle_managerUI.dart';
import 'components/bag_widget.dart';
import 'components/board_grid.dart';
import 'components/dpad.dart';
import 'components/rotation.dart';
import 'components/spatial_grid.dart';

enum RotationOrientation { CLOCKWISE, ANTICLOCKWISE }

class SpatialPuzzleWidget extends StatelessWidget {
  final SpatialPuzzle puzzle;

  // REPOSITORIOS
  late final BoardManagementRepository boardManagementRepository;
  late final BagManagementRepository bagManagementRepository;
  late final SelectedPieceManagementRepository
      selectedPieceManagementRepository;
  late final SoundManagementRepository soundManagementRepository;
  late final SpatialManagementRepository spatialManagerRepository;

  // Use Cases
  late final LevelManagementUseCases levelManagementUseCases;

  SpatialPuzzleWidget({
    required this.puzzle,
    required LevelManagementRepository levelManagementRepository,
    Key? key,
  }) : super(key: key) {
    // Repositorios propios del puzzle
    selectedPieceManagementRepository = PieceManagementRepositoryImpl(
        selectedPieceManager: puzzle.selectedPieceManager);

    bagManagementRepository =
        BagManagementRepositoryImpl(bag: puzzle.bagOfPieces);

    boardManagementRepository =
        BoardManagementRepositoryImpl(board: puzzle.puzzleSlidingBoard);

    soundManagementRepository =
        SoundManagementRepositoryImpl(soundManager: puzzle.soundManager);

    spatialManagerRepository =
        SpatialManagementRepositoryImpl(model: puzzle.spatialManager);

    // Manejo de niveles
    levelManagementUseCases = LevelManagementUseCases(
        levelManagementRepository: levelManagementRepository);

    // Inicializar board con nivel elegido
    BoardGridUseCases(boardManagementRepository: this.boardManagementRepository)
        .initializeSlidingBoard(
      board: puzzle.puzzleSlidingBoard,
      puzzleType: PuzzleType.SPATIAL,
      puzzleLevel: puzzle.puzzleLevel,
    );

    SpatialManagementUseCases(
            spatialManagementRepository: spatialManagerRepository)
        .initializeSpatialBoard(
            spatialManager: puzzle.spatialManager,
            puzzleLevel: puzzle.puzzleLevel);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SpatialProviders(
      puzzle: this.puzzle,
      child: Column(
        children: [
          Card(
            color: Colors.white.withOpacity(0.50),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SpatialPuzzleBody(
                  selectedPieceManagementRepository:
                      this.selectedPieceManagementRepository,
                  boardManagementRepository: this.boardManagementRepository,
                  bagManagementRepository: this.bagManagementRepository,
                  soundManagementRepository: this.soundManagementRepository,
                  spatialManagementRepository: this.spatialManagerRepository,
                  levelManagementUseCases: this.levelManagementUseCases,
                ),
              ),
            ),
          ),
        ],
      ),
    )
        // child: Column(
        //   children: [
        //     Container(
        //       color: Colors.blueGrey,
        //       height: 400,
        //       width: 600,
        //       child: PrettyText("Placeholder - Espacial"),
        //       // child: Image.asset(
        //       //     'assets/puzzle_sound.png'
        //       // ),
        //     ),
        //     const SizedBox(
        //       height: 15,
        //     ),
        //     Consumer<NavigationManager>(
        //       builder: (_, navigationManager, __) {
        //         return ElevatedButton(
        //           child: const Text(
        //             "NEXT LEVEL",
        //             style: TextStyle(
        //               fontSize: 24,
        //             ),
        //           ),
        //           style: ElevatedButton.styleFrom(
        //             primary: Colors.blueGrey,
        //             padding:
        //                 const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(12.0),
        //             ),
        //           ),
        //           onPressed: () async {
        //             // Check if they already completed 5 puzzles
        //             if (await levelManagementUseCases.isGameComplete()) {
        //               // Jump to End Screen
        //               navigationManager.setCurrentScreen = ScreenType.POST_PUZZLE;
        //               navigationManager.update();
        //             } else {
        //               navigationManager.setCurrentScreen = ScreenType.PRE_PUZZLE;
        //
        //               // Obtain puzzle
        //               navigationManager.setPuzzle =
        //                   Puzzle(puzzleLevel: PuzzleLevel.LV1);
        //
        //               // Update Previous Puzzle
        //               this
        //                   .levelManagementUseCases
        //                   .updatePreviousPuzzle(puzzleType: PuzzleType.SPATIAL);
        //
        //               // Guarda un valor temporal que será usado por la pantalla PRE
        //               this
        //                   .levelManagementUseCases
        //                   .updateTempType(puzzleType: PuzzleType.SPATIAL);
        //
        //               // Update UI
        //               navigationManager.update();
        //               Provider.of<ValueNotifier<int>>(context, listen: false)
        //                   .value++;
        //             }
        //           },
        //         );
        //       },
        //     ),
        //   ],
        // ),
        );
  }
}

class SpatialProviders extends StatelessWidget {
  final SpatialPuzzle puzzle;
  final Widget child;

  const SpatialProviders({required this.puzzle, required this.child, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<BoardUI>(
          create: (context) => BoardUI(board: puzzle.puzzleSlidingBoard)),
      ChangeNotifierProvider<BagUI>(
        create: (context) => BagUI(bag: puzzle.bagOfPieces),
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
      ChangeNotifierProvider<SpatialUI>(
        create: (context) => SpatialUI(spatialModel: puzzle.spatialManager),
      ),
      ChangeNotifierProvider<SpatialPieceManagerUI>(
          create: (context) => SpatialPieceManagerUI()),
      ChangeNotifierProvider<UniversalPuzzleToggleManager>(
        create: (context) => UniversalPuzzleToggleManager(),
      ),
    ], child: child);
  }
}

class SpatialPuzzleBody extends StatelessWidget {
  final SelectedPieceManagementRepository selectedPieceManagementRepository;
  final BoardManagementRepository boardManagementRepository;
  final BagManagementRepository bagManagementRepository;
  final SoundManagementRepository soundManagementRepository;
  final SpatialManagementRepository spatialManagementRepository;

  late final SpatialManagementUseCases spatialCases;
  late final BagManagementUseCases bagCases;
  late final SelectedPieceManagementUseCases selectedCases;
  late final DpadUseCases dpadCases;

  final LevelManagementUseCases levelManagementUseCases;

  static const rotationCycle = [
    PieceRotation.UP,
    PieceRotation.RIGHT,
    PieceRotation.DOWN,
    PieceRotation.LEFT
  ];

  SpatialPuzzleBody(
      {required this.selectedPieceManagementRepository,
      required this.boardManagementRepository,
      required this.bagManagementRepository,
      required this.soundManagementRepository,
      required this.spatialManagementRepository,
      required this.levelManagementUseCases,
      Key? key})
      : super(key: key) {
    // Usecases
    spatialCases = SpatialManagementUseCases(
        spatialManagementRepository: spatialManagementRepository);

    bagCases =
        BagManagementUseCases(bagManagementRepository: bagManagementRepository);

    selectedCases = SelectedPieceManagementUseCases(
        selectedPieceManagementRepository: selectedPieceManagementRepository);

    dpadCases =
        DpadUseCases(boardManagementRepository: boardManagementRepository);
  }

  void _rotate(
      {required BuildContext context,
      required RotationOrientation orientation}) {
    int rotation = (orientation == RotationOrientation.CLOCKWISE) ? 1 : -1;

    final Piece currentPiece = selectedCases.getCurrentSelectedPiece();

    final int currentRotationCycleIndex =
        rotationCycle.indexOf(currentPiece.rotation);
    final int nextRotationCycleIndex =
        (currentRotationCycleIndex + rotation) % rotationCycle.length;

    bagCases.rotatePieceInBag(
      puzzlePiece: currentPiece,
      newRotation: rotationCycle[nextRotationCycleIndex],
    );
    Provider.of<BagUI>(context, listen: false).update();
  }

  void _move(
      {required BuildContext context,
      required BoardDirection direction}) async {
    final Piece piece = selectedCases.getCurrentSelectedPiece();

    if (piece.isNullPiece) return;

    final Piece outPiece =
        dpadCases.movePiece(direction: direction, puzzlePiece: piece);

    Provider.of<BoardUI>(context, listen: false).update();

    if (!outPiece.isNullPiece) {
      bagCases.addToBag(puzzlePiece: outPiece);

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
              'Try clicking the orange button that says \'Change to Bag\'\nand check all the available pieces you have!\n\n'
              'After that, click one of those pieces.',
          onPressed: () {
            Provider.of<HintManager>(context, listen: false)
                .showChangeToBagHint = false;
            Provider.of<HintManager>(context, listen: false)
                .showClickOnChangeButton = true;
            Provider.of<HintManager>(context, listen: false).update();
          },
        );
      }
    }
  }

  void removePieceFromPuzzle(BuildContext context) {
    // obtener pieza
    final Piece piece = selectedCases.getCurrentSelectedPiece();

    // revisar si esta en bolsa
    if (!piece.isNullPiece && piece.location == PieceLocation.SPATIAL_BOARD) {
      //Piece basePiece = spatialCases.getBasePieceByPosition(row: piece.y, col: piece.x);
      spatialCases.removePieceFromBoard(piece: piece);
      bagCases.addToBag(puzzlePiece: piece);

      if (spatialCases.isPuzzleCorrect()) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Warning',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              content: Text(
                'Level complete!',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            );
          },
        );
      }

      Provider.of<SelectedPieceManagerUI>(context, listen: false)
          .selectedPiece = Piece.createNullPiece();
      Provider.of<BoardPieceManagerUI>(context, listen: false).selectedPiece =
          Piece.createNullPiece();
      Provider.of<SpatialPieceManagerUI>(context, listen: false).selectedPiece =
          Piece.createNullPiece();

      Provider.of<BagUI>(context, listen: false).update();
      Provider.of<SpatialUI>(context, listen: false).update();
    }
  }

  void removeAllPieces(BuildContext context) {
    List<Piece> lista = spatialCases.removeAllPiecesFromBoard();

    lista.forEach((element) {
      bagCases.addToBag(puzzlePiece: element);
    });

    Provider.of<SelectedPieceManagerUI>(context, listen: false).selectedPiece =
        Piece.createNullPiece();
    Provider.of<BoardPieceManagerUI>(context, listen: false).selectedPiece =
        Piece.createNullPiece();
    Provider.of<SpatialPieceManagerUI>(context, listen: false).selectedPiece =
        Piece.createNullPiece();

    Provider.of<BagUI>(context, listen: false).update();
    Provider.of<SpatialUI>(context, listen: false).update();
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
                    (Provider.of<UniversalPuzzleToggleManager>(
                                // operador ternario
                                context,
                                listen: true)
                            .canShowBag)
                        ? Column(
                            // consecuencia del operador ternario
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
                                        soundManagementRepository,
                                    boardType: BoardType.SPATIAL,
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
                        : Column(
                            children: [
                              GestureDetector(
                                  child: BagWidget(
                                    bagOfPieces: Provider.of<BagUI>(context,
                                            listen: true)
                                        .bag,
                                    toggleRotation: Provider.of<ToggleRotation>(
                                        context,
                                        listen: true),
                                    height: 500,
                                    width: 550,
                                    selectedPieceManagementRepository:
                                        selectedPieceManagementRepository,
                                    soundManagementRepository:
                                        soundManagementRepository,
                                    bagType: BagType.SPATIAL,
                                  ),
                                  onTap: () {
                                    removePieceFromPuzzle(context);
                                  }),
                              const SizedBox(
                                height: 16,
                              ),
                              RotationButtons(
                                scale: 1.0,
                                isActive: Provider.of<ToggleRotation>(context,
                                        listen: true)
                                    .canRotate,
                                rotateLeft: () => _rotate(
                                    context: context,
                                    orientation:
                                        RotationOrientation.ANTICLOCKWISE),
                                rotateRight: () => _rotate(
                                    context: context,
                                    orientation: RotationOrientation.CLOCKWISE),
                              ),
                            ],
                          ),
                  ],
                ),
                const SizedBox(
                  width: 50,
                ),
                Column(
                  children: [
                    SpatialGrid(
                        spatialManager:
                            Provider.of<SpatialUI>(context, listen: true)
                                .spatialModel,
                        selectedManager: selectedPieceManagementRepository),
                    const SizedBox(
                      height: 20,
                      width: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          removeAllPieces(context);
                        },
                        child: const Text(
                          "Clear board",
                        )),
                  ],
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
                  .updatePreviousPuzzle(puzzleType: PuzzleType.SPATIAL);

              // Guarda un valor temporal que será usado por la pantalla PRE
              this
                  .levelManagementUseCases
                  .updateTempType(puzzleType: PuzzleType.SPATIAL);

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
