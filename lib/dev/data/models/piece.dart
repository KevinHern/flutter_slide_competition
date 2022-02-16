import 'dart:ui';

import 'package:flutter_slide_competition/dev/data/models/sound.dart';

enum PieceRotation { UP, DOWN, LEFT, RIGHT }
enum PieceType { AUDIO, SPATIAL, DUMMY, FIXED, EMPTY }
// dummy: se mueve pero no se puede sacar
// fixed: no se puede mover, orilla
// empty: representa espacios vacíos, pseudo-null porque hay null-safety
enum PieceShape { DOT, SQUARE, LINE, L }
enum PieceLocation { BOARD, BAG, SPATIAL_BOARD }

List<Color> someColors = [
  Color(0xFF417858),
  Color(0xFF4F8F7D),
  Color(0xFF5DA4A5),
  Color(0xFF6BA2BC),
  Color(0xFF7A9CD2),
  Color(0xFF8991E8),
  Color(0xFF94B5EC),
  Color(0xFF9ED5EF),
  Color(0xFFA9F1F2),
  Color(0xFFB5F5E3),
];

class Piece {
  static int totalPieces = 1;
  late PieceRotation _rotation;
  late PieceType _type;
  late PieceShape _shape;
  late PieceLocation _location;
  late int _x;
  late int _y;
  late Color _color;
  late MusicalNote _musicalNote;
  bool _isSelected = false; // al momento de crearse no hay nada seleccionado

  Piece({required PieceRotation rotation}) {
    this._rotation = rotation;
    this._shape = PieceShape.DOT;
  }

  Piece.withDetails({
    required PieceRotation rotation,
    required PieceType type,
    required PieceShape shape,
    required PieceLocation location,
    MusicalNote musicalNote = MusicalNote.NONE,
  }) {
    this._rotation = rotation;
    this._type = type;
    this._shape = shape;
    this._location = location;
    this._musicalNote = musicalNote;

    if (type == PieceType.AUDIO) {
      switch (musicalNote) {
        case MusicalNote.C: _color = Color(0xFF7B912F); break;
        case MusicalNote.D: _color = Color(0xFFA1A738); break;
        case MusicalNote.E: _color = Color(0xFFBEAF42); break;
        case MusicalNote.F: _color = Color(0xFFD4AD4C); break;
        case MusicalNote.G: _color = Color(0xFFE9A656); break;
        case MusicalNote.A: _color = Color(0xFFEF986F); break;
        case MusicalNote.B: _color = Color(0xFFF49388); break;
        case MusicalNote.C8: _color = Color(0xFFF8A3AD); break;
        default: _color = Color(0xFF000000);
      }
    } else if (type == PieceType.SPATIAL) {
      _color = someColors[totalPieces++ % 10];
    }
  }

  Piece.createNullPiece() {
    this._rotation = PieceRotation.UP;
    this._location = PieceLocation.BOARD;
    this._shape = PieceShape.DOT;
    this._type = PieceType.EMPTY;
    this._musicalNote = MusicalNote.NONE;
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
  MusicalNote get musicalNote => this._musicalNote;

  // setters
  set rotation(PieceRotation rotation) => this._rotation = rotation;
  set type(PieceType type) => this._type = type;
  set shape(PieceShape shape) => this._shape = shape;
  set location(PieceLocation location) => this._location = location;
  set x(int x) => this._x = x;
  set y(int y) => this._y = y;
  set isSelected(bool isSelected) => this._isSelected = isSelected;
  set color(Color color) => this._color = color;

  String toString() {
    //return "shape: ${shape} - x: ${x} - y: ${y}";
    return "shape: ${shape} type: ${type}";
  }

  // toggle
  bool toggleSelection() {
    this._isSelected = !this._isSelected;
    return this._isSelected;
  }
}

// Clase dummy para rellenar por el null safety
// class NullPiece extends Piece {
//   NullPiece() : super(rotation : PieceRotation.UP);
// }
