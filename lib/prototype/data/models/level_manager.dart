enum PuzzleType { SOUND, SPATIAL, NONE }

class LevelManager {
  late List<PuzzleType> _puzzleRecord;
  late int _soundCount;
  late int _spatialCount;
  late int _completed;

  LevelManager() {
    this._puzzleRecord = [
      PuzzleType.NONE,
      PuzzleType.NONE,
      PuzzleType.NONE,
      PuzzleType.NONE,
      PuzzleType.NONE
    ];
    this._soundCount = 0;
    this._spatialCount = 0;
    this._completed = 0;
  }

  // Getters
  PuzzleType get previousPuzzle {
    if (this._completed <= 1) {
      return PuzzleType.NONE;
    } else {
      return this._puzzleRecord[this._completed - 2];
    }
  }

  int get totalSound => this._soundCount;
  int get totalSpatial => this._spatialCount;
  int get totalCompleted => this._completed;

  // Setters
  set previousPuzzle(PuzzleType puzzleType) =>
      this._puzzleRecord[this._completed - 1] = puzzleType;

  void increaseCount({required PuzzleType puzzleType}) {
    if (puzzleType == PuzzleType.SOUND)
      this._soundCount++;
    else
      this._spatialCount++;

    this._completed++;
  }
}
