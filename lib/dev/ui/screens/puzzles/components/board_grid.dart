import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/board.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/repositories/board_management_impl.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/board_grid_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/selected_piece_usecases.dart';
import 'package:flutter_slide_competition/dev/ui/models/boardUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_board_pieceUI.dart';
import 'package:provider/provider.dart';

class BoardGrid extends StatelessWidget {
  final Board board;
  final SelectedPieceManagementRepository selectedManager;

  const BoardGrid({
    required this.board,
    required this.selectedManager,
    Key? key
  }) : super(key: key);

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
        // Si se tiene la pieza nula (casilla vacía)
        if (board.board[row][col].isNullPiece) {
          // Pintar de gris
          cuadritos[row*8 + col] = Container(height: 10, width: 10, color: Colors.grey);

          // O de azul si es la salida
          if (col == 7 && (row == 3 || row == 4)) {
            cuadritos[row*8 + col] = Container(height: 10, width: 10, color: Colors.blueGrey);
          }

        // Si hay una pieza válida
        } else {
          MaterialColor c = Colors.grey;

          // Elegir su color según su forma
          if (board.board[row][col].type == PieceType.DUMMY) {
            c = Colors.brown;
          } else {
            switch (board.board[row][col].shape) {
              case PieceShape.DOT:    { c = Colors.red; } break;
              case PieceShape.SQUARE: { c = Colors.blue; } break;
              case PieceShape.LINE:   { c = Colors.yellow; } break;
              case PieceShape.L:      { c = Colors.green; } break;
            }
          }

          // Y pintar el cuadro correspondiente
          cuadritos[row*8 + col] = Container(height: 10, width: 10, color: c);

          if (board.board[row][col] == selPiece) {
            cuadritos[row*8 + col] = Container(height: 10, width: 10, color: Colors.purpleAccent);
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
          for(var item in cuadritos) GestureDetector(
            onTap: () {
              int index = cuadritos.indexOf(item);
              int row = index ~/8;
              int col = index % 8;

              // Una pieza puede ocupar varias casillas
              // Obtiene la pieza base
              Piece piece = BoardGridUseCases(
                  boardManagementRepository: BoardManagementRepositoryImpl(
                    board:board
                  )
              ).getBasePieceByPosition(row: row, col: col);

              SelectedPieceManagementUseCases(
                selectedPieceManagementRepository: selectedManager
              ).selectPiece(puzzlePiece: piece);

              Provider.of<BoardPieceManagerUI>(context, listen: false).selectedPiece = piece;
              Provider.of<BoardUI>(context, listen: false).update();

              print("row: $row - col: $col");
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

