import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/board.dart';
import 'package:flutter_slide_competition/dev/data/models/level_manager.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/repositories/board_management_impl.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/sound_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/board_grid_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/selected_piece_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/sound_management_usecases.dart';
import 'package:flutter_slide_competition/dev/ui/models/boardUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_board_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_spatial_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/toggle_managerUI.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../models/bagUI.dart';
import '../../../models/spatialUI.dart';

enum BoardType { SOUND, SPATIAL }

class BoardGrid extends StatefulWidget {
  final Board board;
  final SelectedPieceManagementRepository selectedManager;
  final SoundManagementRepository soundManagementRepository;
  final BoardType boardType;

  final Function moveUp, moveDown, moveLeft, moveRight;

  const BoardGrid(
      {required this.board,
      required this.selectedManager,
      required this.soundManagementRepository,
      required this.boardType,
      required this.moveUp,
      required this.moveDown,
      required this.moveLeft,
      required this.moveRight,
      Key? key})
      : super(key: key);

  @override
  _BoardGridState createState() => _BoardGridState();
}

class _BoardGridState extends State<BoardGrid> {
  // Self parameters
  late final AudioPlayer player;
  final GlobalKey _key = GlobalKey();

  late final BoardGridUseCases boardCases;
  late final SelectedPieceManagementUseCases selectedCases;
  late final SoundManagementUseCases soundCases;

  @override
  void initState() {
    super.initState();
    this.player = AudioPlayer();

    boardCases = BoardGridUseCases(
        boardManagementRepository: BoardManagementRepositoryImpl(
            board:widget.board
        )
    );

    selectedCases = SelectedPieceManagementUseCases(
        selectedPieceManagementRepository: widget.selectedManager
    );

    soundCases = SoundManagementUseCases(
        soundManagementRepository: widget.soundManagementRepository
    );
  }

  @override
  void dispose() {
    this.player.dispose();
    super.dispose();
  }

  Piece selectPieceOnClick(int row, int col) {
    // Una pieza puede ocupar varias casillas
    // Obtiene la pieza base
    Piece piece = boardCases.getBasePieceByPosition(row: row, col: col);

    if (piece.isNullPiece) {
      // Si fue una casilla vacía
      // Deseleccionar
      selectedCases.unselectPiece();
    } else {
      // Si fue una pieza válida
      // Seleccionar
      selectedCases.selectPiece(puzzlePiece: piece);

      if (widget.boardType == BoardType.SOUND) {
        if (piece.type == PieceType.AUDIO) {
          soundCases.playPieceSound(
              player: player,
              piece: piece
          );
        }
      }
    }

    return piece;
  }

  void updateProvidersAfterClick (Piece piece) {
    // Desactivar rotacion
    Provider.of<ToggleRotation>(context, listen: false).canRotate = false;

    // Actualizar pieza seleccionada
    Provider.of<SelectedPieceManagerUI>(context, listen: false).selectedPiece = piece;
    Provider.of<BoardPieceManagerUI>(context, listen: false).selectedPiece = piece;

    // Se hizo click en tablero, actualizar colores para mostrar pieza seleccionada
    Provider.of<BagUI>(context, listen: false).update();
    Provider.of<BoardUI>(context, listen: false).update();

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
    // Obtener la pieza seleccionada
    Piece selPiece = Provider.of<BoardPieceManagerUI>(context, listen: false).selectedPiece;

    // Lista de 64 casillas representando al board
    List<Container> cuadritos = List.generate(64, (_) => Container());

    // Para cada fila
    for (int row = 0; row < 8; row++) {
      // Para cada columna
      for (int col = 0; col < 8; col++) {
        Piece piece = widget.board.board[row][col];

        // Si se tiene la pieza nula (casilla vacía)
        if (piece.isNullPiece) {
          // Pintar de gris
          cuadritos[row * 8 + col] =
              Container(height: 10, width: 10, color: CupertinoColors.systemGrey2);

          // O de azul si es la salida
          if (col == 7 && (row == 3 || row == 4)) {
            cuadritos[row * 8 + col] =
                Container(
                    height: 10,
                    width: 10,
                    color: CupertinoColors.systemGrey4,
                    child: const Center(
                        child: Text(
                          "->",
                          style: TextStyle(fontSize: 24),
                        )
                    )
                );
          }

          // Si hay una pieza válida
        } else {
          Color c = piece.color;

          // Y pintar el cuadro correspondiente
          cuadritos[row * 8 + col] = Container(height: 10, width: 10, color: c);

          if (piece == selPiece) {
            cuadritos[row * 8 + col] =
                Container(height: 10, width: 10, color: Colors.yellowAccent);
          }
        }
      }
    }

    return Container(
      color: Colors.white,
      width: 400,
      height: 400,
      child: GridView.count(
        crossAxisCount: 8,
        children: [
          for (var item in cuadritos)
            GestureDetector(
              // TODO: Si pieza con tipo SOUND ya esta seleccionada, no volver a reproducir audio

              onVerticalDragStart: (DragStartDetails details) {
                // Obtener fila y columna
                int index = cuadritos.indexOf(item);
                int row = index ~/ 8;
                int col = index % 8;

                Piece piece = selectPieceOnClick(row, col);
                if (widget.boardType == BoardType.SPATIAL) {
                  updateProvidersAfterClick(piece);
                } else {
                  updateSoundProvidersAfterClick(piece);
                }
              },
              onVerticalDragEnd: (DragEndDetails details) {
                print(
                    "${details.primaryVelocity} (negativo arriba, positivo abajo)");

                if (details.primaryVelocity! > 0) {
                  widget.moveDown();
                } else if (details.primaryVelocity! < 0) {
                  widget.moveUp();
                }
              },

              onHorizontalDragStart: (DragStartDetails details) {
                // Obtener fila y columna
                int index = cuadritos.indexOf(item);
                int row = index ~/ 8;
                int col = index % 8;

                Piece piece = selectPieceOnClick(row, col);
                if (widget.boardType == BoardType.SPATIAL) {
                  updateProvidersAfterClick(piece);
                } else {
                  updateSoundProvidersAfterClick(piece);
                }
              },
              onHorizontalDragEnd: (DragEndDetails details) {
                print(
                    "${details.primaryVelocity} (negativo izquierda, positivo derecha)");

                if (details.primaryVelocity! > 0) {
                  widget.moveRight();
                } else if (details.primaryVelocity! < 0) {
                  widget.moveLeft();
                }
              },

              // Se hizo click en alguna casilla del tablero
              onTap: () {
                // Obtener fila y columna
                int index = cuadritos.indexOf(item);
                int row = index ~/ 8;
                int col = index % 8;

                Piece piece = selectPieceOnClick(row, col);

                if (widget.boardType == BoardType.SPATIAL) {
                  updateProvidersAfterClick(piece);
                } else {
                  updateSoundProvidersAfterClick(piece);
                }
              },
              child: item,
            )
        ],
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
    );
  }
}
