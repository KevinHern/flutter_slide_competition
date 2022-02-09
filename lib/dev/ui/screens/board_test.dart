import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/board.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/ui/models/boardUI.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/board_grid.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/dpad.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/puzzle_button.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/rotation.dart';
import 'package:provider/provider.dart';

import '../utils/my_utils.dart';

class BoardTestScreen extends StatelessWidget {
  final double scale;
  final double height = 40, width = 40;
  final double padding = 5;
  const BoardTestScreen({required this.scale, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MyUtils.setScreenPadding(context: context),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              ChangeNotifierProvider<BoardUI>(
                create: (context) => BoardUI(board: Board()),
                child: Consumer<BoardUI>(
                  builder: (_, boardUI, __) {

                    // TODO: Quitar estas piezas, agregadas solo para probar
                    boardUI.board.addPiece(
                        piece: Piece.withDetails(
                            rotation: PieceRotation.UP,
                            type: PieceType.SPATIAL,
                            shape: PieceShape.DOT,
                            location: PieceLocation.BOARD
                        ),
                        row: 1,
                        col: 1
                    );
                    boardUI.board.addPiece(
                        piece: Piece.withDetails(
                            rotation: PieceRotation.UP,
                            type: PieceType.SPATIAL,
                            shape: PieceShape.DOT,
                            location: PieceLocation.BOARD
                        ),
                        row: 0,
                        col: 0
                    );
                    boardUI.board.addPiece(
                        piece: Piece.withDetails(
                            rotation: PieceRotation.UP,
                            type: PieceType.SPATIAL,
                            shape: PieceShape.SQUARE,
                            location: PieceLocation.BOARD
                        ),
                        row: 1,
                        col: 1
                    );
                    boardUI.board.addPiece(
                        piece: Piece.withDetails(
                            rotation: PieceRotation.UP,
                            type: PieceType.SPATIAL,
                            shape: PieceShape.LINE,
                            location: PieceLocation.BOARD
                        ),
                        row: 0,
                        col: 4
                    );
                    boardUI.board.addPiece(
                        piece: Piece.withDetails(
                            rotation: PieceRotation.LEFT,
                            type: PieceType.SPATIAL,
                            shape: PieceShape.LINE,
                            location: PieceLocation.BOARD
                        ),
                        row: 0,
                        col: 7
                    );
                    boardUI.board.addPiece(
                        piece: Piece.withDetails(
                            rotation: PieceRotation.UP,
                            type: PieceType.SPATIAL,
                            shape: PieceShape.L,
                            location: PieceLocation.BOARD
                        ),
                        row: 5,
                        col: 0
                    );
                    boardUI.board.addPiece(
                        piece: Piece.withDetails(
                            rotation: PieceRotation.DOWN,
                            type: PieceType.SPATIAL,
                            shape: PieceShape.L,
                            location: PieceLocation.BOARD
                        ),
                        row: 4,
                        col: 1
                    );
                    boardUI.board.addPiece(
                        piece: Piece.withDetails(
                            rotation: PieceRotation.RIGHT,
                            type: PieceType.SPATIAL,
                            shape: PieceShape.L,
                            location: PieceLocation.BOARD
                        ),
                        row: 4,
                        col: 5
                    );
                    boardUI.board.addPiece(
                        piece: Piece.withDetails(
                            rotation: PieceRotation.LEFT,
                            type: PieceType.SPATIAL,
                            shape: PieceShape.L,
                            location: PieceLocation.BOARD
                        ),
                        row: 5,
                        col: 6
                    );
                    // TODO: Quitar estas piezas, agregadas solo para probar

                    return BoardGrid(board: boardUI.board);
                  }
                ),
              ),
              DPad(
                scale: scale,
                isActive: false,
                upPress: () => {},
                rightPress: () => {},
                downPress: () => {},
                leftPress: () => {},
              ),
              const SizedBox(
                height: 50,
              ),
              RotationButtons(
                scale: scale,
                isActive: true,
                rotateLeft: () => {},
                rotateRight: () => {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
