import 'package:flutter_slide_competition/dev/data/models/piece.dart';

enum SoundType { NOTES, CHORD }
enum MusicalNote { C, D, E, F, G, A, B, C8, NONE }

class SoundManager {
  int _userSlot = 0;
  late final SoundType _soundPuzzleType;
  late final List<MusicalNote> _template;
  late final List<Piece> _userNotes;
  SoundManager({
    required SoundType soundPuzzleType,
    required List<MusicalNote> template,
  }) {
    this._soundPuzzleType = soundPuzzleType;
    this._template = template;
    this._userNotes = [];
    for (int i = 0; i < template.length; i++)
      this._userNotes.add(Piece.createNullPiece());
  }

  SoundManager.createDummySoundManager() {
    this._soundPuzzleType = SoundType.NOTES;
    this._template = const [MusicalNote.A, MusicalNote.B, MusicalNote.C];
    this._userNotes = [];
  }

  // Getters
  SoundType get soundPuzzleType => this._soundPuzzleType;
  List<MusicalNote> get templateNotes => this._template;
  List<Piece> get userNotes => this._userNotes;
  bool get isUserSetComplete => this._userSlot == this._template.length;
  bool get isUserSetEmpty => this._userSlot == 0;
  int get numberSlotsUsed => this._userSlot;
  int get totalNotes => this._template.length;

  void setMusicalPiece({required Piece piece}) {
    this._userNotes[this._userSlot++] = piece;
  }

  Piece eraseLastNote() {
    final Piece piece = this._userNotes[this._userSlot - 1];
    this._userNotes[this._userSlot - 1] = Piece.createNullPiece();
    this._userSlot--;
    return piece;
  }
}
