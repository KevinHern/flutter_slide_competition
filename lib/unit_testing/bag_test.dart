// Basic Imports
import 'package:flutter/material.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/bag.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/selected_piece_manager.dart';
import 'package:flutter_slide_competition/dev/data/models/sound.dart';
import 'package:flutter_slide_competition/dev/data/repositories/sound_management_impl.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/bag_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';

// Repositories
import 'package:flutter_slide_competition/dev/data/repositories/bag_management_impl.dart';
import 'package:flutter_slide_competition/dev/data/repositories/selected_piece_management_impl.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/sound_management_contract.dart';

// Use Cases
import 'package:flutter_slide_competition/dev/domain/usecases/bag_management_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/selected_piece_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/sound_management_usecases.dart';
import 'package:flutter_slide_competition/dev/ui/models/sound_slotUI.dart';

// Extra Widgets
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/bag_widget.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/rotation.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/sound_slot.dart';

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
  final SoundManager soundModel = SoundManager(
    soundPuzzleType: SoundType.NOTES,
    template: const [MusicalNote.C, MusicalNote.E, MusicalNote.G],
  );
  late final SelectedPieceManager selectedPieceManager;

  // Repositories
  late final SelectedPieceManagementRepository
      selectedPieceManagementRepository;
  late final BagManagementRepository bagManagementRepository;
  late final SoundManagementRepository soundManagementRepository;

  final double scale;
  BagTestScreen({this.scale = 2.5, Key? key}) : super(key: key) {
    // Adding Dummy Pieces
    bagPieces.addPiece(
      puzzlePiece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.AUDIO,
        shape: PieceShape.L,
        musicalNote: MusicalNote.C,
        location: PieceLocation.BAG,
      ),
    );

    bagPieces.addPiece(
      puzzlePiece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.SPATIAL,
        shape: PieceShape.LINE,
        musicalNote: MusicalNote.E,
        location: PieceLocation.BAG,
      ),
    );

    bagPieces.addPiece(
      puzzlePiece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.SPATIAL,
        shape: PieceShape.DOT,
        musicalNote: MusicalNote.G,
        location: PieceLocation.BAG,
      ),
    );

    bagPieces.addPiece(
      puzzlePiece: Piece.withDetails(
        rotation: PieceRotation.LEFT,
        type: PieceType.SPATIAL,
        shape: PieceShape.SQUARE,
        musicalNote: MusicalNote.A,
        location: PieceLocation.BAG,
      ),
    );

    // Initializing Piece Manager
    this.selectedPieceManager =
        SelectedPieceManager(puzzlePieces: this.bagPieces.pieces);

    // Repositories Initialization
    this.selectedPieceManagementRepository = PieceManagementRepositoryImpl(
        selectedPieceManager: this.selectedPieceManager);
    this.bagManagementRepository =
        BagManagementRepositoryImpl(bag: this.bagPieces);
    this.soundManagementRepository =
        SoundManagementRepositoryImpl(soundManager: this.soundModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppProviders(
        bagPieces: this.bagPieces,
        selectedPieceManager: this.selectedPieceManager,
        soundModel: this.soundModel,
        child: Padding(
          padding: MyUtils.setScreenPadding(context: context),
          child: Center(
            child: SingleChildScrollView(
              child: BagSoundTestBody(
                scale: 2.5,
                selectedPieceManagementRepository:
                    this.selectedPieceManagementRepository,
                bagManagementRepository: this.bagManagementRepository,
                soundManagementRepository: this.soundManagementRepository,
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
  final SoundManager soundModel;
  final Widget child;
  const AppProviders(
      {required this.bagPieces,
      required this.selectedPieceManager,
      required this.soundModel,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // For Spatial Puzzles
        ChangeNotifierProvider<ToggleRotation>(
          create: (context) => ToggleRotation(canRotate: true),
        ),
        // For Audio Puzzles
        ChangeNotifierProvider<SoundSlotUI>(
          create: (context) => SoundSlotUI(sound: soundModel),
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

class BagSpatialTestBody extends StatelessWidget {
  final double scale;
  final SelectedPieceManagementRepository selectedPieceManagementRepository;
  final BagManagementRepository bagManagementRepository;
  final SoundManagementRepository soundManagementRepository;
  static const rotationCycle = [
    PieceRotation.UP,
    PieceRotation.RIGHT,
    PieceRotation.DOWN,
    PieceRotation.LEFT
  ];

  const BagSpatialTestBody(
      {required this.scale,
      required this.selectedPieceManagementRepository,
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
          bagType: BagType.SPATIAL,
          bagOfPieces: Provider.of<BagUI>(context, listen: true).bag,
          toggleRotation: Provider.of<ToggleRotation>(context, listen: true),
          height: 500,
          selectedPieceManagementRepository:
              this.selectedPieceManagementRepository,
          soundManagementRepository: this.soundManagementRepository,
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

class BagSoundTestBody extends StatelessWidget {
  final double scale;
  final SelectedPieceManagementRepository selectedPieceManagementRepository;
  final BagManagementRepository bagManagementRepository;
  final SoundManagementRepository soundManagementRepository;

  const BagSoundTestBody(
      {required this.scale,
      required this.selectedPieceManagementRepository,
      required this.bagManagementRepository,
      required this.soundManagementRepository,
      Key? key})
      : super(key: key);

  /*
  - El Modelo 'SoundManager' es nuestro modelo de datos que manejará el pattern matching entre el usuario y el template.
  Hice refactorización y al final utilizo 1 SoundManager tanto para Notas como Acordes

  - SoundSlotUI es simplemente un intermediario que escucha cambios en el Modelo 'SoundManager' y es utilizado para actualizar el Widget SoundSlot()

  - ButtonsSound es un Widget que tiene los botones 'Play template!' y 'Play my notes!'
  Tiene por separado un Array de AudioPlay(). AudioPlay() es una clase con tratamiento especial. Es necesario el uso de StatefulWidget
  El primero reproduce el sonido de las notas/acorde del template y el último reproduce las notas del usuario hasta que haya completado todos los slots

  - Bag Widget sufró modificaciones. Antes era un StatelessWidget ahora es un StatefulWidget debido a que tiene integrado un AudioPlay.
  Cada vez que se haga click en una pieza de la bolsa se producirá el sonido respectivo. Además, tiene un parámetro extra que es "BagType" para poder discernir qué código ejecutar al presionar las piezas
   */

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // UI widgets definitions in: components → sound_slot.dart
        // Provider UI model definition in: ui → models → sound_slotui.dar
        const SoundSlot(),
        const SizedBox(
          height: 20,
        ),
        // Definition in: components → sound_slot.dart
        ButtonsSound(
          soundManagementRepository: this.soundManagementRepository,
        ),
        const SizedBox(
          height: 20,
        ),
        BagWidget(
          bagType: BagType.SOUND,
          bagOfPieces: Provider.of<BagUI>(context, listen: true).bag,
          toggleRotation: null,
          height: 500,
          selectedPieceManagementRepository:
              this.selectedPieceManagementRepository,
          soundManagementRepository: this.soundManagementRepository,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Text('Add To Slot'),
              onPressed: Provider.of<SoundSlotUI>(context, listen: true)
                      .soundModel
                      .isUserSetComplete
                  ? null
                  : () {
                      // Initializing Use Cases
                      final selectedPieceUseCases =
                          SelectedPieceManagementUseCases(
                              selectedPieceManagementRepository:
                                  this.selectedPieceManagementRepository);

                      final bagUseCases = BagManagementUseCases(
                          bagManagementRepository:
                              this.bagManagementRepository);

                      final soundUseCases = SoundManagementUseCases(
                          soundManagementRepository:
                              this.soundManagementRepository);

                      // --- Actual OnTap Execuiton --- //
                      final selectedPiece =
                          selectedPieceUseCases.getCurrentSelectedPiece();

                      if (!selectedPiece.isNullPiece) {
                        // Unselecting current Piece
                        selectedPieceUseCases.unselectPiece();

                        // Remove the piece from the bag
                        if (!bagUseCases.removeFromBag(piece: selectedPiece))
                          throw Exception(
                              'Remove Piece from Bag: Piece not found');

                        // Add to slot
                        soundUseCases.addPieceToSlot(piece: selectedPiece);

                        // Update the reference of the UI of which piece has been selected
                        Provider.of<SelectedPieceManagerUI>(context,
                                listen: false)
                            .selectPiece = Piece.createNullPiece();
                        // Updating UI
                        Provider.of<SoundSlotUI>(context, listen: false)
                            .update();
                        Provider.of<BagUI>(context, listen: false).update();
                        Provider.of<SelectedPieceManagerUI>(context,
                                listen: false)
                            .update();

                        // Comparing if the user set is equal to the template
                        if (soundUseCases.isSoundPuzzleComplete()) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                title: Text('Warning'),
                                content: Text('Level complete!'),
                              );
                            },
                          );
                        } else {
                          if (soundUseCases.isUserSetComplete()) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Text('Warning'),
                                  content: Text('Wrong sequence!'),
                                );
                              },
                            );
                          }
                        }
                      }
                    },
            ),
            ElevatedButton(
              child: Text('Remove Last One Added'),
              onPressed: Provider.of<SoundSlotUI>(context, listen: true)
                      .soundModel
                      .isUserSetEmpty
                  ? null
                  : () {
                      // Initializing Use Cases

                      final bagUseCases = BagManagementUseCases(
                          bagManagementRepository:
                              this.bagManagementRepository);

                      final soundUseCases = SoundManagementUseCases(
                          soundManagementRepository:
                              this.soundManagementRepository);

                      // --- Actual OnTap Execution --- //

                      // Remove the last added piece to the slots
                      final Piece piece = soundUseCases.removeLastPieceAdded();

                      // Add to bag
                      bagUseCases.addToBag(puzzlePiece: piece);

                      // Updating UI
                      Provider.of<SoundSlotUI>(context, listen: false).update();
                      Provider.of<BagUI>(context, listen: false).update();
                    },
            ),
            ElevatedButton(
              child: Text('Remove All'),
              onPressed: Provider.of<SoundSlotUI>(context, listen: true)
                      .soundModel
                      .isUserSetEmpty
                  ? null
                  : () {
                      // Initializing Use Cases

                      final bagUseCases = BagManagementUseCases(
                          bagManagementRepository:
                              this.bagManagementRepository);

                      final soundUseCases = SoundManagementUseCases(
                          soundManagementRepository:
                              this.soundManagementRepository);

                      // --- Actual OnTap Execution --- //
                      final int slotsUsed = soundUseCases.getSlotsUsed();

                      for (int i = 0; i < slotsUsed; i++) {
                        // Remove the last added piece to the slots
                        final Piece piece =
                            soundUseCases.removeLastPieceAdded();

                        // Add to bag
                        bagUseCases.addToBag(puzzlePiece: piece);
                      }

                      // Updating UI
                      Provider.of<SoundSlotUI>(context, listen: false).update();
                      Provider.of<BagUI>(context, listen: false).update();
                    },
            ),
          ],
        ),
      ],
    );
  }
}
