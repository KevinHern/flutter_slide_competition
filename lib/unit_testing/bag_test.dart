// Basic Imports
import 'package:flutter/material.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/bag.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/selected_piece_manager.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/bag_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';

// Repositories
import 'package:flutter_slide_competition/dev/data/repositories/bag_management_impl.dart';
import 'package:flutter_slide_competition/dev/data/repositories/selected_piece_management_impl.dart';

// Use Cases
import 'package:flutter_slide_competition/dev/domain/usecases/bag_management_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/selected_piece_usecases.dart';

// Extra Widgets
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/bag_widget.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/rotation.dart';

// State Management
import 'package:flutter_slide_competition/dev/ui/models/bagUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/toggle_buttons.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_pieceUI.dart';
import 'package:provider/provider.dart';

// Misc Stuff
import 'package:flutter_slide_competition/dev/ui/utils/my_utils.dart';

class BagTestScreen extends StatelessWidget {
  // Models Initialization
  final Bag bagPieces = Bag(puzzlePieces: []);
  late final SelectedPieceManager selectedPieceManager;

  // Repositories
  late final SelectedPieceManagementRepository
      selectedPieceManagementRepository;
  late final BagManagementRepository bagManagementRepository;

  final double scale;
  BagTestScreen({this.scale = 2.5, Key? key}) : super(key: key) {
    // Adding Dummy Pieces
    bagPieces.addPiece(
      puzzlePiece: Piece.withDetails(
          rotation: PieceRotation.LEFT,
          type: PieceType.SPATIAL,
          shape: PieceShape.L,
          location: PieceLocation.BOARD),
    );

    bagPieces.addPiece(
      puzzlePiece: Piece.withDetails(
          rotation: PieceRotation.LEFT,
          type: PieceType.SPATIAL,
          shape: PieceShape.LINE,
          location: PieceLocation.BOARD),
    );

    bagPieces.addPiece(
      puzzlePiece: Piece.withDetails(
          rotation: PieceRotation.LEFT,
          type: PieceType.SPATIAL,
          shape: PieceShape.DOT,
          location: PieceLocation.BOARD),
    );

    bagPieces.addPiece(
      puzzlePiece: Piece.withDetails(
          rotation: PieceRotation.LEFT,
          type: PieceType.SPATIAL,
          shape: PieceShape.SQUARE,
          location: PieceLocation.BOARD),
    );

    // Initializing Piece Manager
    this.selectedPieceManager =
        SelectedPieceManager(puzzlePieces: this.bagPieces.pieces);

    // Repositories Initialization
    this.selectedPieceManagementRepository = PieceManagementRepositoryImpl(
        selectedPieceManager: this.selectedPieceManager);
    this.bagManagementRepository =
        BagManagementRepositoryImpl(bag: this.bagPieces);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppProviders(
        bagPieces: this.bagPieces,
        selectedPieceManager: this.selectedPieceManager,
        child: Padding(
          padding: MyUtils.setScreenPadding(context: context),
          child: Center(
            child: SingleChildScrollView(
              child: BagTestBody(
                scale: 2.5,
                selectedPieceManagementRepository:
                    this.selectedPieceManagementRepository,
                bagManagementRepository: this.bagManagementRepository,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppProviders extends StatelessWidget {
  final Bag bagPieces;
  final SelectedPieceManager selectedPieceManager;
  final Widget child;
  const AppProviders(
      {required this.bagPieces,
      required this.selectedPieceManager,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ToggleRotation>(
          create: (context) => ToggleRotation(canRotate: true),
        ),
        ChangeNotifierProvider<BagUI>(
          create: (context) => BagUI(bag: this.bagPieces),
        ),
        ChangeNotifierProvider<SelectedPieceManagerUI>(
          create: (context) => SelectedPieceManagerUI(),
        ),
      ],
      child: this.child,
    );
  }
}

enum RotationOrientation { CLOCKWISE, ANTICLOCKWISE }

class BagTestBody extends StatelessWidget {
  final double scale;
  final SelectedPieceManagementRepository selectedPieceManagementRepository;
  final BagManagementRepository bagManagementRepository;
  static const rotationCycle = [
    PieceRotation.UP,
    PieceRotation.RIGHT,
    PieceRotation.DOWN,
    PieceRotation.LEFT
  ];
  const BagTestBody(
      {required this.scale,
      required this.selectedPieceManagementRepository,
      required this.bagManagementRepository,
      Key? key})
      : super(key: key);

  void _rotate(
      {required BuildContext context,
      required RotationOrientation orientation}) {
    int rotation = (orientation == RotationOrientation.CLOCKWISE) ? 1 : -1;

    final Piece currentPiece = SelectedPieceManagementUseCases(
            selectedPieceManagementRepository:
                this.selectedPieceManagementRepository)
        .getCurrentSelectedPiece();

    final int currentRotationCycleIndex =
        rotationCycle.indexOf(currentPiece.rotation);
    final int nextRotationCycleIndex =
        (currentRotationCycleIndex + rotation) % rotationCycle.length;

    BagManagementUseCases(bagManagementRepository: this.bagManagementRepository)
        .rotatePieceInBag(
      puzzlePiece: currentPiece,
      newRotation: rotationCycle[nextRotationCycleIndex],
    );
    Provider.of<BagUI>(context, listen: false).update();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BagWidget(
          bagOfPieces: Provider.of<BagUI>(context, listen: true).bag,
          toggleRotation: Provider.of<ToggleRotation>(context, listen: true),
          height: 500,
          selectedPieceManagementRepository:
              this.selectedPieceManagementRepository,
        ),
        const SizedBox(
          height: 50,
        ),
        RotationButtons(
          scale: scale,
          isActive:
              Provider.of<ToggleRotation>(context, listen: true).canRotate,
          rotateLeft: () => _rotate(
              context: context, orientation: RotationOrientation.ANTICLOCKWISE),
          rotateRight: () => _rotate(
              context: context, orientation: RotationOrientation.CLOCKWISE),
        ),
        const SizedBox(
          height: 50,
        ),
        Consumer<ToggleRotation>(
          builder: (_, toggleRotation, __) {
            return ElevatedButton(
              onPressed: () {
                toggleRotation.canRotate = false;
                toggleRotation.update();
              },
              child: Text('Disable Rotate Buttons'),
            );
          },
        ),
      ],
    );
  }
}
