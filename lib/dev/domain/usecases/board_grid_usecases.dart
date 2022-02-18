// Models
import 'package:flutter_slide_competition/dev/data/models/level_manager.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/board.dart';

// Contracts
import 'package:flutter_slide_competition/dev/domain/repositories/board_management_contract.dart';

import '../../data/models/puzzle.dart';

class BoardGridUseCases {
  final BoardManagementRepository boardManagementRepository;

  BoardGridUseCases({required this.boardManagementRepository});

  Piece getBasePieceByPosition({required int row, required int col}) {
    return this.boardManagementRepository.getBasePiece(row: row, col: col);
  }

  void initializeSlidingBoard({
    required Board board,
    required PuzzleType puzzleType,
    required PuzzleLevel puzzleLevel,
  }) {
    if (puzzleType == PuzzleType.SOUND) {
      switch (puzzleLevel) {
        case PuzzleLevel.LV1:
          this.boardManagementRepository.createAudioLevelOne(board: board);
          break;
        case PuzzleLevel.LV2:
          this.boardManagementRepository.createAudioLevelTwo(board: board);
          break;
        case PuzzleLevel.LV3:
          this.boardManagementRepository.createAudioLevelThree(board: board);
          break;
      }
    } else if (puzzleType == PuzzleType.SPATIAL) {
      switch (puzzleLevel) {
        case PuzzleLevel.LV1:
          this.boardManagementRepository.createSpatialLevelOne(board: board);
          break;
        case PuzzleLevel.LV2:
          this.boardManagementRepository.createSpatialLevelTwo(board: board);
          break;
        case PuzzleLevel.LV3:
          this.boardManagementRepository.createSpatialLevelThree(board: board);
          break;
      }
    } else
      throw Exception('Board Grid Use Cases: Unkown puzzle Type detected');
  }
}
