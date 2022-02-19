// Basic Imports
import 'package:flutter/material.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/bag.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/sound.dart';
import 'package:flutter_slide_competition/dev/data/models/level_manager.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/sound_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/selected_piece_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/sound_management_usecases.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/toggle_managerUI.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/puzzle_piece_icon.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

// State Management
import 'package:flutter_slide_competition/dev/ui/models/bagUI.dart';

import '../../../models/boardUI.dart';
import '../../../models/selected_board_pieceUI.dart';
import '../../../models/selected_spatial_pieceUI.dart';
import '../../../models/spatialUI.dart';
import 'board_grid.dart';

enum BagType { SOUND, SPATIAL }

class PieceBagTitle extends StatelessWidget {
  final Piece piece;
  const PieceBagTitle({required this.piece, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (piece.shape) {
      case PieceShape.DOT:
        return Text(
          'Small Square Piece',
          style: Theme.of(context).textTheme.subtitle1,
        );
      case PieceShape.LINE:
        return Text(
          'Rectangle Piece',
          style: Theme.of(context).textTheme.subtitle1,
        );
      case PieceShape.L:
        return Text(
          'L Piece',
          style: Theme.of(context).textTheme.subtitle1,
        );
      case PieceShape.SQUARE:
        return Text(
          'Big Square',
          style: Theme.of(context).textTheme.subtitle1,
        );
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
        return Text(
          'Orientation: None',
          style: Theme.of(context).textTheme.bodyText1,
        );
      case PieceShape.LINE:
        switch (piece.rotation) {
          case PieceRotation.UP:
          case PieceRotation.DOWN:
            return Text(
              'Orientation: Horizontal',
              style: Theme.of(context).textTheme.bodyText1,
            );
          case PieceRotation.LEFT:
          case PieceRotation.RIGHT:
            return Text(
              'Orientation: Vertical',
              style: Theme.of(context).textTheme.bodyText1,
            );
          default:
            throw Exception('Unkown Rotation detected for LINE shaped piece');
        }
      case PieceShape.L:
        switch (piece.rotation) {
          case PieceRotation.UP:
            return Text(
              'Orientation: Up',
              style: Theme.of(context).textTheme.bodyText1,
            );
          case PieceRotation.DOWN:
            return Text(
              'Orientation: Down',
              style: Theme.of(context).textTheme.bodyText1,
            );
          case PieceRotation.LEFT:
            return Text(
              'Orientation: Left',
              style: Theme.of(context).textTheme.bodyText1,
            );
          case PieceRotation.RIGHT:
            return Text(
              'Orientation: Right',
              style: Theme.of(context).textTheme.bodyText1,
            );
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
        return Text(
          'Musical Note: C (do)',
          style: Theme.of(context).textTheme.bodyText1,
        );
      case MusicalNote.D:
        return Text(
          'Musical Note: D (re)',
          style: Theme.of(context).textTheme.bodyText1,
        );
      case MusicalNote.E:
        return Text(
          "Musical Note: E (mi)",
          style: Theme.of(context).textTheme.bodyText1,
        );
      case MusicalNote.F:
        return Text(
          'Musical Note: F (fa)',
          style: Theme.of(context).textTheme.bodyText1,
        );
      case MusicalNote.G:
        return Text(
          'Musical Note: G (sol)',
          style: Theme.of(context).textTheme.bodyText1,
        );
      case MusicalNote.A:
        return Text(
          'Musical Note: A (la)',
          style: Theme.of(context).textTheme.bodyText1,
        );
      case MusicalNote.B:
        return Text(
          'Musical Note: B (si)',
          style: Theme.of(context).textTheme.bodyText1,
        );
      case MusicalNote.C8:
        return Text(
          'Musical Note: C-octave (do-octave)',
          style: Theme.of(context).textTheme.bodyText1,
        );
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

  // UI Parameters
  final double elevation, borderRadius;
  final Color bagTileColor, shadowColor, selectedTileColor, borderColor;

  BagWidget({
    required this.bagOfPieces,
    required this.bagType,
    required this.height,
    this.width = double.infinity,
    required SelectedPieceManagementRepository
        selectedPieceManagementRepository,
    @required SoundManagementRepository? soundManagementRepository,
    @required this.toggleRotation,
    this.elevation = 8.0,
    this.borderRadius = 15.0,
    this.borderColor = const Color(0xFF8A84E2),
    this.bagTileColor = const Color(0xFFAFAFDC),
    this.shadowColor = const Color(0xFF84AFE6),
    this.selectedTileColor = const Color(0xFFEE79C3),
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

  void updateProvidersAfterClick (Piece piece) {
    // Desactivar rotacion
    Provider.of<ToggleRotation>(context, listen: false).canRotate = true;

    // Actualizar pieza seleccionada
    Provider.of<SelectedPieceManagerUI>(context, listen: false).selectedPiece = piece;
    Provider.of<BoardPieceManagerUI>(context, listen: false).selectedPiece = piece;

    // Se hizo click en tablero, actualizar colores para mostrar pieza seleccionada
    Provider.of<BagUI>(context, listen: false).update();
    Provider.of<BoardUI>(context, listen: false).update();

    if (widget.bagType == PuzzleType.SOUND) return;

    Provider.of<SpatialPieceManagerUI>(context, listen: false).selectedPiece = piece;
    Provider.of<SpatialUI>(context, listen: false).update();
  }

  void updateSoundProvidersAfterClick (Piece piece) {
    // Desactivar rotacion
    Provider.of<ToggleRotation>(context, listen: false).canRotate = false;

    // Actualizar pieza seleccionada
    Provider.of<SelectedPieceManagerUI>(context, listen: false).selectedPiece = piece;
    Provider.of<BoardPieceManagerUI>(context, listen: false).selectedPiece = piece;

    // Se hizo click en tablero, actualizar colores para mostrar pieza seleccionada
    Provider.of<BagUI>(context, listen: false).update();
    Provider.of<BoardUI>(context, listen: false).update();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.elevation,
      color: Colors.transparent,
      shadowColor: widget.shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 200,
          maxWidth: widget.width,
          maxHeight: widget.height,
          minHeight: widget.height / 2,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 5,
              color: widget.borderColor,
            ),
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius)),
          ),
          child: (widget.bagOfPieces.length == 0)
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.all(Radius.circular(widget.borderRadius)),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.all(Radius.circular(widget.borderRadius)),
                  ),
                  child: ListView.builder(
                    itemCount: widget.bagOfPieces.length,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Card(
                          elevation: widget.elevation,
                          shadowColor: widget.shadowColor,
                          color: (Provider.of<SelectedPieceManagerUI>(context,
                                          listen: true)
                                      .selectedPiece ==
                                  widget.bagOfPieces.pieces[index])
                              ? widget.selectedTileColor
                              : widget.bagTileColor,
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
                              widget.selectedPieceManagementUseCases
                                  .selectPiece(
                                      puzzlePiece:
                                          widget.bagOfPieces.pieces[index]);

                              // Update the reference of the UI of which piece has been selected
                              Provider.of<SelectedPieceManagerUI>(context,
                                          listen: false)
                                      .selectedPiece =
                                  widget.selectedPieceManagementUseCases
                                      .getCurrentSelectedPiece();

                              // TODO: probar
                              //updateProvidersAfterClick(widget.bagOfPieces.pieces[index]);

                              if (widget.bagType == BoardType.SPATIAL) {
                                updateProvidersAfterClick(
                                    widget.bagOfPieces.pieces[index]
                                );
                              } else {
                                updateSoundProvidersAfterClick(
                                    widget.bagOfPieces.pieces[index]
                                );
                              }

                              // Execute the action depending on the current puzzle type
                              if (widget.bagType == BagType.SPATIAL) {
                                // Toggle the rotation buttons and update the buttons UI
                                widget.toggleRotation!.canRotate = true;
                                widget.toggleRotation!.update();
                              } else {
                                // Play piece's sound
                                await widget.soundManagementUseCases!
                                    .playPieceSound(
                                        player: this.player,
                                        piece:
                                            widget.bagOfPieces.pieces[index]);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
