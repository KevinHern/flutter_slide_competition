import 'dart:ui';

enum PieceRotation { UP, DOWN, LEFT, RIGHT }
enum PieceType { AUDIO, SPATIAL, DUMMY, FIXED, EMPTY }
  // dummy: se mueve pero no se puede sacar
  // fixed: no se puede mover, orilla
  // empty: representa espacios vacíos, pseudo-null porque hay null-safety
enum PieceShape { DOT, SQUARE, LINE, L }
enum PieceLocation { BOARD, BAG, SPATIAL_BOARD }

class Piece {
  late PieceRotation _rotation;
  late PieceType _type;
  late PieceShape _shape;
  late PieceLocation _location;
  late int _x;
  late int _y;
  late Color _color;
  bool _isSelected = false;        // al momento de crearse no hay nada seleccionado

  // todo: sound y onTap en siguiente fase

  Piece({required PieceRotation rotation}) {
    this._rotation = rotation;
    this._shape = PieceShape.DOT;
  }

  Piece.withDetails({
    required PieceRotation rotation,
    required PieceType type,
    required PieceShape shape,
    required PieceLocation location
  }) {
    this._rotation = rotation;
    this._type = type;
    this._shape = shape;
    this._location = location;
  }

  Piece.createNullPiece() {
    this._rotation = PieceRotation.UP;
    this._location = PieceLocation.BOARD;
    this._shape = PieceShape.DOT;
    this._type = PieceType.EMPTY;
  }

  // getters
  PieceRotation get rotation => this._rotation;
  PieceType get type => this._type;
  PieceShape get shape => this._shape;
  PieceLocation get location => this._location;
  int get x => this._x;
  int get y => this._y;
  bool get isSelected => this._isSelected;
  Color get color => this._color;
  bool get isNullPiece => (this._type == PieceType.EMPTY);

  // setters
  set rotation(PieceRotation rotation) => this._rotation = rotation;
  set type(PieceType type) => this._type = type;
  set shape(PieceShape shape) => this._shape = shape;
  set location(PieceLocation location) => this._location = location;
  set x(int x) => this._x = x;
  set y(int y) => this._y = y;
  set isSelected(bool isSelected) => this._isSelected = isSelected;
  set color(Color color) => this._color = color;

  // toggle
  bool toggleSelection () {
    this._isSelected = !this._isSelected;
    return this._isSelected;
  }
}

// Clase dummy para rellenar por el null safety
// class NullPiece extends Piece {
//   NullPiece() : super(rotation : PieceRotation.UP);
// }
