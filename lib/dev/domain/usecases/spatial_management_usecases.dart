// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

// Contracts
import 'package:flutter_slide_competition/dev/domain/repositories/spatial_management_contract.dart';

import '../../data/models/puzzle.dart';
import '../../data/models/spatial.dart';

class SpatialManagementUseCases {
  final SpatialManagementRepository spatialManagementRepository;

  SpatialManagementUseCases({required this.spatialManagementRepository});

  bool addPieceToBoard({required Piece piece, required int row, required int col}) {
    return spatialManagementRepository.addPiece(piece: piece, row: row, col: col);
  }

  bool checkIfValidPositionOnBoard({required Piece piece, required int row, required int col}) {
    return spatialManagementRepository.checkIfEmptySpace(piece: piece, row: row, col: col);
  }

  Piece removePieceFromBoard({required Piece piece}) {
    return spatialManagementRepository.removePiece(piece: piece);
  }

  Piece getBasePieceByPosition({required int row, required int col}) {
    return spatialManagementRepository.getBasePiece(row: row, col: col);
  }

  bool isPuzzleCorrect() => spatialManagementRepository.compareBoards();

  int getEmptySpaces() => spatialManagementRepository.checkEmptySpace();

  void initializeSpatialBoard({
    required SpatialManager spatialManager,
    required PuzzleLevel puzzleLevel,
  }) {
    switch (puzzleLevel) {
      case PuzzleLevel.LV1:
        this.spatialManagementRepository.createSpatialLevelOne(
            spatialManager: spatialManager);
        break;
      case PuzzleLevel.LV2:
        this.spatialManagementRepository.createSpatialLevelTwo(
            spatialManager: spatialManager);
        break;
      case PuzzleLevel.LV3:
        this.spatialManagementRepository.createSpatialLevelThree(
            spatialManager: spatialManager);
        break;
    }
  }
}
