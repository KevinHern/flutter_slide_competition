import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/board.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/spatial.dart';
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

/* Stateless: no necesita state porque no hay nada relacionado con audio */
class SpatialGrid extends StatelessWidget {
  final SpatialManager spatialManager;
  final SelectedPieceManagementRepository selectedManager;

  SpatialGrid({
    required SpatialManager this.spatialManager,
    required SelectedPieceManagementRepository this.selectedManager,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Piece selPiece = Provider.of<BoardPieceManagerUI>(context, listen: false).selectedPiece;

    // Lista de 36 casillas representando al board
    // TODO: List<Container>
    List<Container> cuadritos = List.generate(36, (_) => Container());

    for (int row = 0; row < 6; row++) {
      for (int col = 0; col < 6; col++) {
        Piece targetPiece = spatialManager.targetBoard[row][col];
        Piece userPiece = spatialManager.userBoard[row][col];

        Color c = Colors.grey;

        if (targetPiece.isNullPiece) {
          c = Colors.blueGrey;
        } else {
          c = Colors.lightBlueAccent;
        }

        if (!userPiece.isNullPiece) {
          c = userPiece.color;
        }

        cuadritos[row*6 + col] = Container(height: 10, width: 10, color: c);
      }
    }

    return Container(
      color: Colors.white,
      width: 300,
      height: 300,
      child: GridView.count(
        crossAxisCount: 6,
        children: [
          for(var item in cuadritos) GestureDetector(

            // Se hizo click en alguna casilla del tablero
            onTap: () {
              // Obtener fila y columna
              int index = cuadritos.indexOf(item);
              int row = index ~/ 6;
              int col = index % 6;

              print("spatial grid: x = $col - y = $row");

              //Piece piece = selectPieceOnClick(row, col);
              //updateProvidersAfterClick(piece);
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



