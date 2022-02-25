import 'package:flutter/material.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

// Repositories (Contracts)
import 'package:flutter_slide_competition/dev/domain/repositories/bag_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/sound_management_contract.dart';

// Use Cases
import 'package:flutter_slide_competition/dev/domain/usecases/bag_management_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/selected_piece_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/sound_management_usecases.dart';

// Extra Widgets
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/puzzle_button.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/sound_slot.dart';

// UI (Provider Models)
import 'package:provider/provider.dart';
import 'package:flutter_slide_competition/dev/ui/models/toggle_managerUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/bagUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/sound_slotUI.dart';

import '../../../models/hint_managerUI.dart';

class SoundGameWidget extends StatelessWidget {
  final SoundManagementRepository soundManagementRepository;
  final BagManagementRepository bagManagementRepository;
  final SelectedPieceManagementRepository selectedPieceManagementRepository;

  final double soundSlotWidth;

  const SoundGameWidget(
      {required this.soundManagementRepository,
      required this.bagManagementRepository,
      required this.selectedPieceManagementRepository,
      this.soundSlotWidth = 500,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SoundSlot(
          scale: 1.5,
          width: this.soundSlotWidth,
        ),
        const SizedBox(
          height: 30,
        ),
        ButtonsSound(
          soundManagementRepository: this.soundManagementRepository,
        ),
        const SizedBox(
          height: 30,
        ),
        Stack(
          children: [
            IconPuzzleButton(
              scale: 1.25,
              icon: 'add',
              text: 'Add to Slot',
              buttonColor: const Color(0xFFDFEFCA),
              clickColor: Colors.green,
              shadowColor: const Color(0xFFadbd99),
              onPressed: (Provider.of<SoundSlotUI>(context, listen: true)
                  .soundModel
                  .isUserSetComplete)
                  ? null
                  : () {
                Provider.of<HintManager>(context, listen: false).showClickOnAddButton = false;
                Provider.of<HintManager>(context, listen: false).update();

                // Initializing Use Cases
                final selectedPieceUseCases = SelectedPieceManagementUseCases(
                    selectedPieceManagementRepository:
                    this.selectedPieceManagementRepository);

                final bagUseCases = BagManagementUseCases(
                    bagManagementRepository: this.bagManagementRepository);

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
                    throw Exception('Remove Piece from Bag: Piece not found');

                  // Add to slot
                  soundUseCases.addPieceToSlot(piece: selectedPiece);

                  // Update the reference of the UI of which piece has been selected
                  Provider.of<SelectedPieceManagerUI>(context, listen: false)
                      .selectedPiece = Piece.createNullPiece();
                  // Updating UI
                  Provider.of<SoundSlotUI>(context, listen: false).update();
                  Provider.of<BagUI>(context, listen: false).update();
                  Provider.of<SelectedPieceManagerUI>(context, listen: false)
                      .update();

                  // Comparing if the user set is equal to the template
                  if (soundUseCases.isSoundPuzzleComplete()) {
                    Provider.of<UniversalPuzzleToggleManager>(context,
                        listen: false)
                        .showWinButton = true;
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Yey!',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          content: Text(
                            'Level complete!',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        );
                      },
                    );
                  } else {
                    if (soundUseCases.isUserSetComplete()) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Warning',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            content: Text(
                              'Wrong sequence!',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          );
                        },
                      );
                    }
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Warning',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        content: Text(
                          'You can only add pieces from the bag!',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      );
                    },
                  );
                }
              },
            ),
            Positioned(
              left: 20,
              top: 20,
              child: Visibility(
                // Visibilidad de la animacion controlada por el provider
                visible: Provider.of<HintManager>(context,
                    listen: true)
                    .showClickOnAddButton,
                child: Image.asset(
                  'assets/click.gif',
                  height: 40,
                  width: 40,
                ),
              ),
            ),
          ]
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconPuzzleButton(
              scale: 1.25,
              icon: 'remove',
              text: 'Remove Last One Added',
              buttonColor: const Color(0xFFf29a94),
              clickColor: Colors.red,
              shadowColor: const Color(0xFFbc5b56),
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
            const SizedBox(
              width: 15,
            ),
            IconPuzzleButton(
              scale: 1.25,
              icon: 'remove',
              text: 'Remove All',
              buttonColor: const Color(0xFFf29a94),
              clickColor: Colors.red,
              shadowColor: const Color(0xFFbc5b56),
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
