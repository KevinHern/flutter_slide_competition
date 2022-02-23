// Models
import 'package:flutter_slide_competition/dev/data/models/bag.dart';
import 'package:flutter_slide_competition/dev/data/models/board.dart';
import 'package:flutter_slide_competition/dev/data/models/selected_piece_manager.dart';
import 'package:flutter_slide_competition/dev/data/models/sound.dart';
import 'package:flutter_slide_competition/dev/data/models/spatial.dart';

enum PuzzleLevel { LV1, LV2, LV3 }

class Puzzle {
  // Models
  final Board _board;
  final Bag _bag;
  late final SelectedPieceManager _selectedPieceManager;

  // Self parameters
  late bool puzzleDone = false;
  final PuzzleLevel _puzzleLevel;

  Puzzle({required PuzzleLevel puzzleLevel})
      : this._puzzleLevel = puzzleLevel,
        this._board = Board(),
        this._bag = Bag(puzzlePieces: []) {
    this._selectedPieceManager =
        SelectedPieceManager(puzzlePieces: this._board.puzzlePieces);
  }

  // Getters
  Board get puzzleSlidingBoard => this._board;
  Bag get bagOfPieces => this._bag;
  SelectedPieceManager get selectedPieceManager => this._selectedPieceManager;
  PuzzleLevel get puzzleLevel => this._puzzleLevel;

  // Setters
}

class AuditivePuzzle extends Puzzle {
  late final SoundManager _soundManager;

  AuditivePuzzle(
      {required SoundType soundType, required PuzzleLevel puzzleLevel})
      : super(puzzleLevel: puzzleLevel) {
    switch (puzzleLevel) {
      case PuzzleLevel.LV1:
        this._soundManager = SoundManager(
            soundPuzzleType: soundType,
            template: const [MusicalNote.E, MusicalNote.D, MusicalNote.C]);
        break;
      case PuzzleLevel.LV2:
        this._soundManager = SoundManager(
            soundPuzzleType: soundType,
            template: const [MusicalNote.A, MusicalNote.B, MusicalNote.C8]);
        break;
      case PuzzleLevel.LV3:
        this._soundManager = SoundManager(
            soundPuzzleType: soundType,
            template: const [MusicalNote.C, MusicalNote.E, MusicalNote.G]);
        break;
      default:
        throw Exception(
            'Auditive Puzzle Constructor: Unknown Puzzle Level detected');
    }
  }

  // Getters
  SoundManager get soundManager => this._soundManager;

  // Setters
}

class SpatialPuzzle extends Puzzle {
  final SoundManager _soundManager = SoundManager.createDummySoundManager();
  final SpatialManager _spatialManager = SpatialManager();

  SpatialPuzzle({required PuzzleLevel puzzleLevel})
      : super(puzzleLevel: puzzleLevel) {
    switch (puzzleLevel) {
      case PuzzleLevel.LV1:
        print("spatial lv1");
        break;
      case PuzzleLevel.LV2:
        print("spatial lv2");
        break;
      case PuzzleLevel.LV3:
        print("spatial lv3");
        break;
      default:
        throw Exception(
            'Spatial Puzzle Constructor: Unknown Puzzle Level detected');
    }
  }

  SoundManager get soundManager => this._soundManager;
  SpatialManager get spatialManager => this._spatialManager;
}
