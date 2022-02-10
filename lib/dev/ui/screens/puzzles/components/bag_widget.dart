// Basic Imports
import 'package:flutter/material.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/bag.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/selected_piece_usecases.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/toggle_buttons.dart';
import 'package:provider/provider.dart';

// State Management
import 'package:flutter_slide_competition/dev/ui/models/bagUI.dart';

class PieceBagTitle extends StatelessWidget {
  final Piece piece;
  const PieceBagTitle({required this.piece});

  @override
  Widget build(BuildContext context) {
    switch (piece.shape) {
      case PieceShape.DOT:
        return const Text('Small Square Piece');
      case PieceShape.LINE:
        return const Text('Rectangle Piece');
      case PieceShape.L:
        return const Text('L Piece');
      case PieceShape.SQUARE:
        return const Text('Big Square');
      default:
        throw Exception('Unkown piece shape has been detected');
    }
  }
}

class PieceBagOrientation extends StatelessWidget {
  final Piece piece;
  const PieceBagOrientation({required this.piece, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (piece.shape) {
      case PieceShape.DOT:
      case PieceShape.SQUARE:
        return const Text('Orientation: None');
      case PieceShape.LINE:
        switch (piece.rotation) {
          case PieceRotation.UP:
          case PieceRotation.DOWN:
            return const Text('Orientation: Horizontal');
          case PieceRotation.LEFT:
          case PieceRotation.RIGHT:
            return const Text('Orientation: Vertical');
          default:
            throw Exception('Unkown Rotation detected for LINE shaped piece');
        }
      case PieceShape.L:
        switch (piece.rotation) {
          case PieceRotation.UP:
            return const Text('Orientation: Up');
          case PieceRotation.DOWN:
            return const Text('Orientation: Down');
          case PieceRotation.LEFT:
            return const Text('Orientation: Left');
          case PieceRotation.RIGHT:
            return const Text('Orientation: Right');
          default:
            throw Exception('Unkown Rotation detected for L shaped piece');
        }
      default:
        throw Exception('Unkown piece shape has been detected');
    }
  }
}

class PieceIcon extends StatelessWidget {
  final Piece piece;
  late final String _filename;
  static const double size = 50;

  PieceIcon({required this.piece, Key? key}) : super(key: key) {
    switch (piece.shape) {
      case PieceShape.DOT:
        this._filename = 'dot';
        break;
      case PieceShape.SQUARE:
        this._filename = 'square';
        break;
      case PieceShape.LINE:
        switch (piece.rotation) {
          case PieceRotation.UP:
          case PieceRotation.DOWN:
            this._filename = 'line-H';
            break;
          case PieceRotation.LEFT:
          case PieceRotation.RIGHT:
            this._filename = 'line-V';
            break;
          default:
            throw Exception('Unkown Rotation detected for LINE shaped piece');
        }
        break;
      case PieceShape.L:
        switch (piece.rotation) {
          case PieceRotation.UP:
            this._filename = 'L-up';
            break;
          case PieceRotation.DOWN:
            this._filename = 'L-down';
            break;
          case PieceRotation.LEFT:
            this._filename = 'L-left';
            break;
          case PieceRotation.RIGHT:
            this._filename = 'L-right';
            break;
          default:
            throw Exception('Unkown Rotation detected for L shaped piece');
        }
        break;
      default:
        throw Exception('Unkown piece shape has been detected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Image.asset('icons/' + this._filename + '.png'),
    );
  }
}

class BagWidget extends StatelessWidget {
  final Bag bagOfPieces;
  final ToggleRotation toggleRotation;
  final double height, width;
  late final SelectedPieceManagementUseCases selectedPieceManagementUseCases;
  BagWidget(
      {required this.bagOfPieces,
      required this.toggleRotation,
      required this.height,
      required SelectedPieceManagementRepository
          selectedPieceManagementRepository,
      this.width = double.infinity,
      Key? key})
      : super(key: key) {
    this.selectedPieceManagementUseCases = SelectedPieceManagementUseCases(
        selectedPieceManagementRepository: selectedPieceManagementRepository);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      decoration: BoxDecoration(
        border: Border.all(width: 5),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: (bagOfPieces.length == 0)
          ? Container(
              color: Colors.red,
            )
          : ListView.builder(
              itemCount: bagOfPieces.length,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Card(
                    color: (Provider.of<SelectedPieceManagerUI>(context,
                                    listen: false)
                                .selectedPiece ==
                            bagOfPieces.pieces[index])
                        ? const Color(0xFF00AC9C)
                        : Colors.transparent,
                    child: ListTile(
                      leading: PieceIcon(
                        piece: bagOfPieces.pieces[index],
                      ),
                      title: PieceBagTitle(
                        piece: bagOfPieces.pieces[index],
                      ),
                      subtitle: PieceBagOrientation(
                        piece: bagOfPieces.pieces[index],
                      ),
                      onTap: () {
                        // Everytime the tile gets pressed, register the selected piece as the current piece
                        this.selectedPieceManagementUseCases.selectPiece(
                            puzzlePiece: bagOfPieces.pieces[index]);

                        Provider.of<SelectedPieceManagerUI>(context,
                                    listen: false)
                                .selectPiece =
                            this
                                .selectedPieceManagementUseCases
                                .getCurrentSelectedPiece();

                        // Toggle the rotation buttons and update the buttons UI
                        this.toggleRotation.canRotate = true;
                        this.toggleRotation.update();
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
