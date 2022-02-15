// Basic Imports
import 'package:flutter/material.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/bag.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/sound.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/sound_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/selected_piece_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/sound_management_usecases.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/toggle_buttons.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/puzzle_piece_icon.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

// State Management
import 'package:flutter_slide_competition/dev/ui/models/bagUI.dart';

enum BagType { SOUND, SPATIAL }

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

class PieceBagNote extends StatelessWidget {
  final Piece piece;
  const PieceBagNote({required this.piece, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (piece.musicalNote) {
      case MusicalNote.C:
        return const Text('Musical Note: C (do)');
      case MusicalNote.D:
        return const Text('Musical Note: D (re)');
      case MusicalNote.E:
        return const Text('Musical Note: E (mi)');
      case MusicalNote.F:
        return const Text('Musical Note: F (fa)');
      case MusicalNote.G:
        return const Text('Musical Note: G (sol)');
      case MusicalNote.A:
        return const Text('Musical Note: A (la)');
      case MusicalNote.B:
        return const Text('Musical Note: B (si)');
      case MusicalNote.C8:
        return const Text('Musical Note: C-octave (do-octave)');
      default:
        throw Exception('Unkown piece shape has been detected');
    }
  }
}

class BagWidget extends StatefulWidget {
  // Mandatory Parameters
  final Bag bagOfPieces;
  final double height, width;
  final BagType bagType;
  late final SelectedPieceManagementUseCases selectedPieceManagementUseCases;

  // Optional Parameters
  late final SoundManagementUseCases? soundManagementUseCases;
  final ToggleRotation? toggleRotation;

  BagWidget({
    required this.bagOfPieces,
    required this.bagType,
    required this.height,
    this.width = double.infinity,
    required SelectedPieceManagementRepository
        selectedPieceManagementRepository,
    @required SoundManagementRepository? soundManagementRepository,
    @required this.toggleRotation,
    Key? key,
  }) : super(key: key) {
    //Initializing Use Cases
    this.selectedPieceManagementUseCases = SelectedPieceManagementUseCases(
        selectedPieceManagementRepository: selectedPieceManagementRepository);

    // Initializing optional use cases
    this.soundManagementUseCases = (soundManagementRepository == null)
        ? null
        : SoundManagementUseCases(
            soundManagementRepository: soundManagementRepository);
  }

  @override
  _BagWidgetState createState() => _BagWidgetState();
}

class _BagWidgetState extends State<BagWidget> {
  static const double iconSize = 50;

  // Self parameters
  late final AudioPlayer player;

  @override
  void initState() {
    super.initState();
    this.player = AudioPlayer();
  }

  @override
  void dispose() {
    this.player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(width: 5),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: (widget.bagOfPieces.length == 0)
          ? Container(
              color: Colors.red,
            )
          : ListView.builder(
              itemCount: widget.bagOfPieces.length,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Card(
                    color: (Provider.of<SelectedPieceManagerUI>(context,
                                    listen: true)
                                .selectedPiece ==
                            widget.bagOfPieces.pieces[index])
                        ? const Color(0xFFFFAC9C)
                        : Colors.white,
                    child: ListTile(
                      leading: PieceIcon(
                        size: iconSize,
                        piece: widget.bagOfPieces.pieces[index],
                      ),
                      title: PieceBagTitle(
                        piece: widget.bagOfPieces.pieces[index],
                      ),
                      subtitle: (widget.bagType == BagType.SPATIAL)
                          ? PieceBagOrientation(
                              piece: widget.bagOfPieces.pieces[index],
                            )
                          : PieceBagNote(
                              piece: widget.bagOfPieces.pieces[index],
                            ),
                      onTap: () async {
                        // Everytime the tile gets pressed, register the selected piece as the current piece
                        widget.selectedPieceManagementUseCases.selectPiece(
                            puzzlePiece: widget.bagOfPieces.pieces[index]);

                        // Update the reference of the UI of which piece has been selected
                        Provider.of<SelectedPieceManagerUI>(context,
                                    listen: false)
                                .selectPiece =
                            widget.selectedPieceManagementUseCases
                                .getCurrentSelectedPiece();

                        // Execute the action depending on the current puzzle type
                        if (widget.bagType == BagType.SPATIAL) {
                          // Toggle the rotation buttons and update the buttons UI
                          widget.toggleRotation!.canRotate = true;
                          widget.toggleRotation!.update();
                        } else {
                          // Play piece's sound
                          await widget.soundManagementUseCases!.playPieceSound(
                              player: this.player,
                              piece: widget.bagOfPieces.pieces[index]);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
