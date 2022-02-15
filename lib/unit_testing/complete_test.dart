import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/bag.dart';
import 'package:flutter_slide_competition/dev/data/models/board.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/selected_piece_manager.dart';
import 'package:flutter_slide_competition/dev/data/models/sound.dart';
import 'package:flutter_slide_competition/dev/data/repositories/bag_management_impl.dart';
import 'package:flutter_slide_competition/dev/data/repositories/board_management_impl.dart';
import 'package:flutter_slide_competition/dev/data/repositories/selected_piece_management_impl.dart';
import 'package:flutter_slide_competition/dev/data/repositories/sound_management_impl.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/bag_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/board_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/sound_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/bag_management_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/dpad_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/selected_piece_usecases.dart';
import 'package:flutter_slide_competition/dev/ui/models/bagUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/boardUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_board_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/toggle_buttons.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/bag_widget.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/board_grid.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/dpad.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/rotation.dart';
import 'package:provider/provider.dart';

import '../dev/ui/utils/my_utils.dart';

enum RotationOrientation { CLOCKWISE, ANTICLOCKWISE }

class CompleteTestScreen extends StatelessWidget {
  final double scale;
  final double height = 40, width = 40;
  final double padding = 5;

  // MODELOS
  final Board board = Board();
  final Bag bagPieces = Bag(puzzlePieces: []);
  late final SelectedPieceManager selectedPieceManager;
  final SoundManager soundManager = SoundManager(
      soundPuzzleType: SoundType.NOTES,
      template: const [MusicalNote.C, MusicalNote.E, MusicalNote.G]);

  // REPOSITORIOS
  late final BoardManagementRepository boardManagementRepository;
  late final BagManagementRepository bagManagementRepository;
  late final SelectedPieceManagementRepository
      selectedPieceManagementRepository;
  late final SoundManagementRepository soundManagementRepository;

  CompleteTestScreen({required this.scale, Key? key}) : super(key: key) {
    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.RIGHT,
        type: PieceType.SPATIAL,
        shape: PieceShape.L,
        location: PieceLocation.BOARD,
      ),
      row: 3,
      col: 5,
    );
    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.RIGHT,
        type: PieceType.SPATIAL,
        shape: PieceShape.SQUARE,
        location: PieceLocation.BOARD,
      ),
      row: 1,
      col: 1,
    );
    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.RIGHT,
        type: PieceType.SPATIAL,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 5,
      col: 3,
    );
    board.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.RIGHT,
        type: PieceType.SPATIAL,
        shape: PieceShape.DOT,
        location: PieceLocation.BOARD,
      ),
      row: 6,
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

    soundManagementRepository =
        SoundManagementRepositoryImpl(soundManager: this.soundManager);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AllProviders(
        board: board,
        bagPieces: bagPieces,
        selectedPieceManager: selectedPieceManager,
        child: CompleteTestBody(
          scale: 2.5,
          selectedPieceManagementRepository: selectedPieceManagementRepository,
          boardManagementRepository: boardManagementRepository,
          bagManagementRepository: bagManagementRepository,
          soundManagementRepository: soundManagementRepository,
        ),
      ),
    );
  }
} // fin

class AllProviders extends StatelessWidget {
  final Board board;
  final Bag bagPieces;
  final SelectedPieceManager selectedPieceManager;
  final Widget child;

  const AllProviders(
      {required this.board,
      required this.bagPieces,
      required this.selectedPieceManager,
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
    ], child: child);
  }
}

class CompleteTestBody extends StatelessWidget {
  final double scale;
  final SelectedPieceManagementRepository selectedPieceManagementRepository;
  final BoardManagementRepository boardManagementRepository;
  final BagManagementRepository bagManagementRepository;
  final SoundManagementRepository soundManagementRepository;

  static const rotationCycle = [
    PieceRotation.UP,
    PieceRotation.RIGHT,
    PieceRotation.DOWN,
    PieceRotation.LEFT
  ];

  const CompleteTestBody(
      {required this.scale,
      required this.selectedPieceManagementRepository,
      required this.boardManagementRepository,
      required this.bagManagementRepository,
      required this.soundManagementRepository,
      Key? key})
      : super(key: key);

  void _rotate(
      {required BuildContext context,
      required RotationOrientation orientation}) {
    int rotation = (orientation == RotationOrientation.CLOCKWISE) ? 1 : -1;

    final Piece currentPiece = SelectedPieceManagementUseCases(
            selectedPieceManagementRepository:
                selectedPieceManagementRepository)
        .getCurrentSelectedPiece();

    print("rotando $currentPiece");

    final int currentRotationCycleIndex =
        rotationCycle.indexOf(currentPiece.rotation);
    final int nextRotationCycleIndex =
        (currentRotationCycleIndex + rotation) % rotationCycle.length;

    BagManagementUseCases(bagManagementRepository: bagManagementRepository)
        .rotatePieceInBag(
      puzzlePiece: currentPiece,
      newRotation: rotationCycle[nextRotationCycleIndex],
    );
    Provider.of<BagUI>(context, listen: false).update();
  }

  void _move(
      {required BuildContext context, required BoardDirection direction}) {
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

      // SelectedPieceManagementUseCases(
      //   selectedPieceManagementRepository: selectedPieceManagementRepository
      // ).unselectPiece();

      Provider.of<BagUI>(context, listen: false).update();

      Provider.of<ToggleRotation>(context, listen: false).canRotate = true;
      print("guardando en bolsa: $outPiece");
      Provider.of<SelectedPieceManagerUI>(context, listen: false).selectPiece = outPiece;
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
                ),
                SizedBox(
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
                  BagWidget(
                    bagOfPieces: Provider.of<BagUI>(context, listen: true).bag,
                    toggleRotation:
                        Provider.of<ToggleRotation>(context, listen: true),
                    height: 500,
                    selectedPieceManagementRepository:
                        selectedPieceManagementRepository,
                    soundManagementRepository: this.soundManagementRepository,
                    bagType: BagType.SPATIAL,
                  ),
                  const SizedBox(
                    height: 50,
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
                  const SizedBox(
                    height: 50,
                  ),
                  // Consumer<ToggleRotation>(
                  //   builder: (_, toggleRotation, __) {
                  //     return ElevatedButton(
                  //       onPressed: () {
                  //         toggleRotation.canRotate = false;
                  //         toggleRotation.update();
                  //       },
                  //       child: Text('Disable Rotate Buttons'),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 50, width: 50),
            Column(
              children: [
                Container(
                  color: Colors.blue,
                  width: 200,
                  height: 200,
                  child: const Text("Cuando crezca seré un puzzle :)",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
