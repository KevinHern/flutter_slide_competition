// Basic Imports
import 'package:flutter/material.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

class PieceIcon extends StatelessWidget {
  final Piece piece;
  late final String _filename;
  final double size;

  PieceIcon({required this.size, required this.piece, Key? key})
      : super(key: key) {
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
