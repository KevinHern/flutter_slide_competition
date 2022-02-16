import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/board.dart';
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
import 'package:flutter_slide_competition/dev/ui/models/toggle_buttons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

enum BoardType { SOUND, SPATIAL }

class BoardGrid extends StatefulWidget {
  final Board board;
  final SelectedPieceManagementRepository selectedManager;
  final SoundManagementRepository soundManagementRepository;
  final BoardType boardType;

  final Function moveUp, moveDown, moveLeft, moveRight;

  // TODO: Inicializar usecases

  const BoardGrid({
    required this.board,
    required this.selectedManager,
    required this.soundManagementRepository,
    required this.boardType,
    required this.moveUp,
    required this.moveDown,
    required this.moveLeft,
    required this.moveRight,
    Key? key
  }) : super(key: key);

  @override
  _BoardGridState createState() => _BoardGridState();
}

class _BoardGridState extends State<BoardGrid> {
  // Self parameters
  late final AudioPlayer player;
  final GlobalKey _key = GlobalKey();

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
          cuadritos[row*8 + col] = Container(height: 10, width: 10, color: Colors.grey);

          // O de azul si es la salida
          if (col == 7 && (row == 3 || row == 4)) {
            cuadritos[row*8 + col] = Container(height: 10, width: 10, color: Colors.blueGrey);
          }

          // Si hay una pieza válida
        } else {
          Color c = Colors.grey;

          // Elegir su color según su forma
          if (piece.type == PieceType.DUMMY) {
            c = Colors.brown;
          } else if (piece.type == PieceType.AUDIO || piece.type == PieceType.SPATIAL) {
            c = piece.color;
          } else {
            c = Colors.deepPurple;
          }

          // Y pintar el cuadro correspondiente
          cuadritos[row*8 + col] = Container(height: 10, width: 10, color: c);

          if (piece == selPiece) {
            cuadritos[row*8 + col] = Container(height: 10, width: 10, color: Colors.purpleAccent);
          }
        }
      }
    }

    Piece selectPieceOnClick(int row, int col) {
      // Una pieza puede ocupar varias casillas
      // Obtiene la pieza base
      Piece piece = BoardGridUseCases(
          boardManagementRepository: BoardManagementRepositoryImpl(
              board:widget.board
          )
      ).getBasePieceByPosition(row: row, col: col);

      if (piece.isNullPiece) {
        // Si fue una casilla vacía
        // Deseleccionar
        SelectedPieceManagementUseCases(
            selectedPieceManagementRepository: widget.selectedManager
        ).unselectPiece();
      } else {
        // Si fue una pieza válida
        // Seleccionar
        SelectedPieceManagementUseCases(
            selectedPieceManagementRepository: widget.selectedManager
        ).selectPiece(puzzlePiece: piece);

        if (widget.boardType == BoardType.SOUND) {
          if (piece.type == PieceType.AUDIO) {
            SoundManagementUseCases(
                soundManagementRepository: widget.soundManagementRepository
            ).playPieceSound(
                player: player,
                piece: piece
            );
          }
        }
      }

      return piece;
    }

    void updateProvidersAfterClick (Piece piece) {
      // Se hizo click en tablero, desactivar rotación y selección de bag
      Provider.of<ToggleRotation>(context, listen: false).canRotate = false;
      Provider.of<SelectedPieceManagerUI>(context, listen: false).selectPiece = piece;

      // Se hizo click en tablero, actualizar colores para mostrar pieza seleccionada
      Provider.of<BoardPieceManagerUI>(context, listen: false).selectedPiece = piece;
      Provider.of<BoardUI>(context, listen: false).update();
    }

    return Container(
      color: Colors.white,
      width: 400,
      height: 400,
      child: GridView.count(
        crossAxisCount: 8,
        children: [
          for(var item in cuadritos) GestureDetector(

            // TODO: Si pieza con tipo SOUND ya esta seleccionada, no volver a reproducir audio

            onVerticalDragStart: (DragStartDetails details) {
              // Obtener fila y columna
              int index = cuadritos.indexOf(item);
              int row = index ~/8;
              int col = index % 8;

              Piece piece = selectPieceOnClick(row, col);
              updateProvidersAfterClick(piece);
            },
            onVerticalDragEnd: (DragEndDetails details) {
              print("${details.primaryVelocity} (negativo arriba, positivo abajo)");

              if (details.primaryVelocity! > 0) {
                widget.moveDown();
              } else if (details.primaryVelocity! < 0){
                widget.moveUp();
              }
            },

            onHorizontalDragStart: (DragStartDetails details) {
              // Obtener fila y columna
              int index = cuadritos.indexOf(item);
              int row = index ~/8;
              int col = index % 8;

              Piece piece = selectPieceOnClick(row, col);
              updateProvidersAfterClick(piece);
            },
            onHorizontalDragEnd: (DragEndDetails details) {
              print("${details.primaryVelocity} (negativo izquierda, positivo derecha)");

              if (details.primaryVelocity! > 0) {
                widget.moveRight();
              } else if (details.primaryVelocity! < 0){
                widget.moveLeft();
              }
            },

            // Se hizo click en alguna casilla del tablero
            onTap: () {
              // Obtener fila y columna
              int index = cuadritos.indexOf(item);
              int row = index ~/8;
              int col = index % 8;

              Piece piece = selectPieceOnClick(row, col);
              updateProvidersAfterClick(piece);
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
