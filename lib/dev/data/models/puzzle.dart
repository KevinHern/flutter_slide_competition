class Puzzle {
  late bool puzzleDone;

  Puzzle() {
    this.puzzleDone = false;
  }
}

class AuditivePuzzle extends Puzzle {}

class SpatialPuzzle extends Puzzle {}
