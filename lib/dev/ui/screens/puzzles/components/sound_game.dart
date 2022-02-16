import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/bag_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/sound_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/bag_management_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/selected_piece_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/sound_management_usecases.dart';
import 'package:flutter_slide_competition/dev/ui/models/bagUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/sound_slotUI.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/sound_slot.dart';
import 'package:provider/provider.dart';

class SoundGameWidget extends StatelessWidget {
  final SoundManagementRepository soundManagementRepository;
  final BagManagementRepository bagManagementRepository;
  final SelectedPieceManagementRepository selectedPieceManagementRepository;

  const SoundGameWidget({
    required this.soundManagementRepository,
    required this.bagManagementRepository,
    required this.selectedPieceManagementRepository,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context ) {
    return Expanded(
      child: Column(
        children: [
          const SoundSlot(),
          const SizedBox(
            height: 20,
          ),
          ButtonsSound(
            soundManagementRepository: this.soundManagementRepository,
          ),
          const SizedBox(
            height: 20,
          ),
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
                  throw Exception('Remove Piece from Bag: Piece not found');

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
                        title: Text('Yey!'),
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
          const SizedBox(
            height: 50,
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
          const SizedBox(
            height: 20,
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
    );
  }


}