enum PieceRotation { UP, DOWN, LEFT, RIGHT }

class Piece {
  late PieceRotation _rotation;
  Piece({required PieceRotation rotation}) {
    this._rotation = rotation;
  }

  // getters
  PieceRotation get rotation => this._rotation;

  // setters
  set rotation(PieceRotation rotation) => this._rotation = rotation;
}
