import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/bag.dart';
import 'package:flutter_slide_competition/dev/data/models/board.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/selected_piece_manager.dart';
import 'package:flutter_slide_competition/dev/data/models/sound.dart';
import 'package:flutter_slide_competition/dev/data/models/spatial.dart';
import 'package:flutter_slide_competition/dev/data/repositories/bag_management_impl.dart';
import 'package:flutter_slide_competition/dev/data/repositories/board_management_impl.dart';
import 'package:flutter_slide_competition/dev/data/repositories/selected_piece_management_impl.dart';
import 'package:flutter_slide_competition/dev/data/repositories/sound_management_impl.dart';
import 'package:flutter_slide_competition/dev/data/repositories/spatial_management_impl.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/bag_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/board_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/sound_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/spatial_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/bag_management_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/dpad_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/selected_piece_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/spatial_management_usecases.dart';
import 'package:flutter_slide_competition/dev/ui/models/bagUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/boardUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_board_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_spatial_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/spatialUI.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/bag_widget.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/board_grid.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/dpad.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/rotation.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/spatial_grid.dart';
import 'package:provider/provider.dart';

import '../dev/ui/models/toggle_managerUI.dart';
import '../dev/ui/utils/my_utils.dart';

enum RotationOrientation { CLOCKWISE, ANTICLOCKWISE }

class SpatialTestScreen extends StatelessWidget {
  final double scale;
  final double height = 40, width = 40;
  final double padding = 5;

  // MODELOS
  final Board board = Board();
  final Bag bagPieces = Bag(puzzlePieces: []);
  late final SelectedPieceManager selectedPieceManager;
  final SoundManager soundManager = SoundManager(
      soundPuzzleType: SoundType.NOTES,
      template: const [MusicalNote.A, MusicalNote.B, MusicalNote.C]
  );
  final SpatialManager spatialManager = SpatialManager();

  // REPOSITORIOS
  late final BoardManagementRepository boardManagementRepository;
  late final BagManagementRepository bagManagementRepository;
  late final SelectedPieceManagementRepository selectedPieceManagementRepository;
  late final SoundManagementRepository soundManagementRepository;
  late final SpatialManagementRepository spatialManagerRepository;

  SpatialTestScreen({required this.scale, Key? key}) : super(key: key) {
    spatialManager.addPieceToTargetBoard(
        piece: Piece.withDetails(
          rotation: PieceRotation.LEFT,
          type: PieceType.SPATIAL,
          shape: PieceShape.L,
          location: PieceLocation.SPATIAL_BOARD,
        ),
        row: 0,
        col: 0
    );

    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.SPATIAL,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 3,
      col: 5,
    );
    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.SPATIAL,
        shape: PieceShape.SQUARE,
        location: PieceLocation.BOARD,
        musicalNote: MusicalNote.B,
      ),
      row: 3,
      col: 3,
    );
    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.AUDIO,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
        musicalNote: MusicalNote.C,
      ),
      row: 3,
      col: 1,
    );

    // Las piezas comienzan en board pero se mueven a bag
    selectedPieceManager =
        SelectedPieceManager(puzzlePieces: board.puzzlePieces);

    // Repositories Initialization
    selectedPieceManagementRepository = PieceManagementRepositoryImpl(
        selectedPieceManager: selectedPieceManager);

    bagManagementRepository = BagManagementRepositoryImpl(bag: bagPieces);

    boardManagementRepository = BoardManagementRepositoryImpl(board: board);

    soundManagementRepository = SoundManagementRepositoryImpl(soundManager: this.soundManager);

    spatialManagerRepository = SpatialManagementRepositoryImpl(model: this.spatialManager);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SpatialProviders(
        board: board,
        bagPieces: bagPieces,
        selectedPieceManager: selectedPieceManager,
        soundModel: soundManager,
        spatialModel: spatialManager,
        child: SpatialTestBody(
          scale: 2.5,
          selectedPieceManagementRepository: selectedPieceManagementRepository,
          boardManagementRepository: boardManagementRepository,
          bagManagementRepository: bagManagementRepository,
          soundManagementRepository: soundManagementRepository,
          spatialManagementRepository: spatialManagerRepository,
        ),
      ),
    );
  }
} // fin

class SpatialProviders extends StatelessWidget {
  final Board board;
  final Bag bagPieces;
  final SelectedPieceManager selectedPieceManager;
  final SoundManager soundModel;
  final SpatialManager spatialModel;
  final Widget child;

  const SpatialProviders(
      {required this.board,
        required this.bagPieces,
        required this.selectedPieceManager,
        required this.soundModel,
        required this.spatialModel,
        required this.child,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<BoardUI>(
          create: (context) => BoardUI(board: board)),
      ChangeNotifierProvider<BagUI>(
        create: (context) => BagUI(bag: this.bagPieces),
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
        create: (context) => SpatialUI(spatialModel: spatialModel),
      ),
      ChangeNotifierProvider<SpatialPieceManagerUI>(
          create: (context) => SpatialPieceManagerUI()
      )
    ], child: child);
  }
}

class SpatialTestBody extends StatelessWidget {
  final double scale;
  final SelectedPieceManagementRepository selectedPieceManagementRepository;
  final BoardManagementRepository boardManagementRepository;
  final BagManagementRepository bagManagementRepository;
  final SoundManagementRepository soundManagementRepository;
  final SpatialManagementRepository spatialManagementRepository;

  late final SpatialManagementUseCases spatialCases;
  late final BagManagementUseCases bagCases;
  late final SelectedPieceManagementUseCases selectedCases;
  late final DpadUseCases dpadCases;

  static const rotationCycle = [
    PieceRotation.UP,
    PieceRotation.RIGHT,
    PieceRotation.DOWN,
    PieceRotation.LEFT
  ];

  SpatialTestBody(
      {required this.scale,
        required this.selectedPieceManagementRepository,
        required this.boardManagementRepository,
        required this.bagManagementRepository,
        required this.soundManagementRepository,
        required this.spatialManagementRepository,
        Key? key})
      : super(key: key) {
    // Usecases
    spatialCases = SpatialManagementUseCases(
        spatialManagementRepository: spatialManagementRepository
    );

    bagCases = BagManagementUseCases(
        bagManagementRepository: bagManagementRepository
    );

    selectedCases = SelectedPieceManagementUseCases(
        selectedPieceManagementRepository: selectedPieceManagementRepository
    );

    dpadCases = DpadUseCases(
        boardManagementRepository: boardManagementRepository
    );
  }

  void _rotate({
    required BuildContext context,
    required RotationOrientation orientation
  }) {
    int rotation = (orientation == RotationOrientation.CLOCKWISE) ? 1 : -1;

    final Piece currentPiece = selectedCases.getCurrentSelectedPiece();

    final int currentRotationCycleIndex = rotationCycle.indexOf(currentPiece.rotation);
    final int nextRotationCycleIndex = (currentRotationCycleIndex + rotation) % rotationCycle.length;

    bagCases.rotatePieceInBag(
      puzzlePiece: currentPiece,
      newRotation: rotationCycle[nextRotationCycleIndex],
    );
    Provider.of<BagUI>(context, listen: false).update();
  }

  void _move(
      {required BuildContext context, required BoardDirection direction}) {
    final Piece piece = selectedCases.getCurrentSelectedPiece();

    if (piece.isNullPiece) return;

    final Piece outPiece = dpadCases.movePiece(direction: direction, puzzlePiece: piece);

    Provider.of<BoardUI>(context, listen: false).update();

    if (!outPiece.isNullPiece) {
      bagCases.addToBag(puzzlePiece: outPiece);

      Provider.of<BagUI>(context, listen: false).update();
      Provider.of<ToggleRotation>(context, listen: false).canRotate = true;
      Provider.of<SelectedPieceManagerUI>(context, listen: false).selectedPiece = outPiece;
    }
  }

  void removePieceFromPuzzle (BuildContext context) {
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
                'Yey',
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

      Provider.of<SelectedPieceManagerUI>(context, listen: false).selectedPiece = Piece.createNullPiece();
      Provider.of<BoardPieceManagerUI>(context, listen: false).selectedPiece = Piece.createNullPiece();
      Provider.of<SpatialPieceManagerUI>(context, listen: false).selectedPiece = Piece.createNullPiece();

      Provider.of<BagUI>(context, listen: false).update();
      Provider.of<SpatialUI>(context, listen: false).update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: MyUtils.setScreenPadding(context: context),
        child: Row(
          children: [
            Column(
              children: [
                BoardGrid(
                  board: Provider.of<BoardUI>(context, listen: true).board,
                  selectedManager: selectedPieceManagementRepository,
                  soundManagementRepository: this.soundManagementRepository,
                  boardType: BoardType.SPATIAL,
                  moveUp: () => _move(context: context, direction: BoardDirection.UP),
                  moveRight: () => _move(context: context, direction: BoardDirection.RIGHT),
                  moveDown: () => _move(context: context, direction: BoardDirection.DOWN),
                  moveLeft: () => _move(context: context, direction: BoardDirection.LEFT),
                ),
                const SizedBox(
                  height: 50,
                  width: 50,
                ),
                DPad(
                  scale: scale,
                  isActive: true,
                  upPress: () =>
                      _move(context: context, direction: BoardDirection.UP),
                  rightPress: () =>
                      _move(context: context, direction: BoardDirection.RIGHT),
                  downPress: () =>
                      _move(context: context, direction: BoardDirection.DOWN),
                  leftPress: () =>
                      _move(context: context, direction: BoardDirection.LEFT),
                ),
              ],
            ),
            const SizedBox(height: 50, width: 50),
            Expanded(
              child: Column(
                children: [
                  GestureDetector(
                    child:BagWidget(
                      bagOfPieces: Provider.of<BagUI>(context, listen: true).bag,
                      toggleRotation: Provider.of<ToggleRotation>(context, listen: true),
                      height: 500,
                      selectedPieceManagementRepository: selectedPieceManagementRepository,
                      soundManagementRepository: this.soundManagementRepository,
                      bagType: BagType.SPATIAL,
                    ),
                    onTap: () {
                      removePieceFromPuzzle(context);
                    }
                  ),
                  const SizedBox(
                    height: 50,
                    width: 50,
                  ),
                  RotationButtons(
                    scale: scale,
                    isActive: Provider.of<ToggleRotation>(context, listen: true)
                        .canRotate,
                    rotateLeft: () => _rotate(
                        context: context,
                        orientation: RotationOrientation.ANTICLOCKWISE),
                    rotateRight: () => _rotate(
                        context: context,
                        orientation: RotationOrientation.CLOCKWISE),
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 50,
                width: 50
            ),
            Expanded(
              child: Column(
                children: [
                  SpatialGrid(
                      spatialManager: Provider.of<SpatialUI>(context, listen: true).spatialModel,
                      selectedManager: selectedPieceManagementRepository
                  ),
                  const SizedBox(
                    height: 20,
                    width: 20,
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       addPieceToPuzzle(context);
                  //     },
                  //     child: const Text(
                  //       "Add piece to puzzle",
                  //     )
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  //   width: 20,
                  // ),
                  ElevatedButton(
                      onPressed: () {
                        removePieceFromPuzzle(context);
                      },
                      child: const Text(
                        "Remove piece from puzzle",
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
