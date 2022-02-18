// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

// Contracts
import 'package:flutter_slide_competition/dev/domain/repositories/spatial_management_contract.dart';

class SpatialManagementUseCases {
  final SpatialManagementRepository spatialManagementRepository;

  SpatialManagementUseCases({required this.spatialManagementRepository});

  bool addPieceToBoard({required Piece piece, required int row, required int col}) {
    return spatialManagementRepository.addPiece(piece: piece, row: row, col: col);
  }

  Piece removePieceFromBoard({required Piece piece}) {
    return spatialManagementRepository.removePiece(piece: piece);
  }

  bool movePieceInBoard({required Piece piece, required int row, required int col}) {
    return spatialManagementRepository.movePiece(piece: piece, row: row, col: col);
  }

  Piece getBasePieceByPosition({required int row, required int col}) {
    return spatialManagementRepository.getBasePiece(row: row, col: col);
  }

  bool isPuzzleCorrect() => spatialManagementRepository.compareBoards();

  int getEmptySpaces() => spatialManagementRepository.checkEmptySpace();
}
