import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/board.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/selected_piece_usecases.dart';

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

    List<Container> cuadritos = List.generate(64, (_) => Container());
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (board.board[row][col].isNullPiece) {
          cuadritos[row*8 + col] = Container(height: 10, width: 10, color: Colors.grey);

          if (col == 7 && (row == 3 || row == 4)) {
            cuadritos[row*8 + col] = Container(height: 10, width: 10, color: Colors.blueGrey);
          }
        } else {
          MaterialColor c = Colors.grey;

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

          cuadritos[row*8 + col] = Container(height: 10, width: 10, color: c);
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

              SelectedPieceManagementUseCases(
                  selectedPieceManagementRepository: selectedManager
              ).getByPositionOnGrid(row: row, col: col);

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

