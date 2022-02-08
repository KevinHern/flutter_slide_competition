// Basic Imports
import 'package:flutter/material.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/bag.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/ui/models/toggle_buttons.dart';
import 'package:provider/provider.dart';

// State Management
import 'package:flutter_slide_competition/dev/ui/models/bagUI.dart';

class BagWidget extends StatelessWidget {
  final Bag bagOfPieces;
  final ToggleRotation toggleRotation;
  const BagWidget(
      {required this.bagOfPieces, required this.toggleRotation, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bagOfPieces.length,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      itemBuilder: (context, index) {
        return ListTile(
          // todo: put icons of the pieces here
          //leading: , ← Put icon here of the piece
          title: (bagOfPieces.pieces[index].shape == PieceShape.DOT)
              ? const Text('Small Square Piece')
              : (bagOfPieces.pieces[index].shape == PieceShape.LINE)
                  ? const Text('Rectangle Piece')
                  : (bagOfPieces.pieces[index].shape == PieceShape.L)
                      ? const Text('L Piece')
                      : const Text('Big Square'),
          onTap: () {
            // Everytime the tile gets pressed, register the selected piece as the current piece
            bagOfPieces.pieces[index].isSelected = true;

            // todo: Call UseCases to update the selected piece

            // Toggle the rotation buttons and update the buttons UI
            this.toggleRotation.canRotate = true;
            this.toggleRotation.update();
          },
        );
      },
    );
  }
}
