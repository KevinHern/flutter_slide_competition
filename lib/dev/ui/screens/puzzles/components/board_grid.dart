import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/board.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

class BoardGrid extends StatelessWidget {
  final Board board;

  const BoardGrid({
    required this.board,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Container> cuadritos = List.generate(64, (_) => Container());
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (board.board[row][col] is NullPiece) {
          cuadritos[row*8 + col] = Container(height: 10, width: 10, color: Colors.grey);
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
        children: cuadritos,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
    );
  }
}

