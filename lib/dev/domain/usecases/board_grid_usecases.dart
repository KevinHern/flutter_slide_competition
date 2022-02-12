// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/board.dart';

// Contracts
import 'package:flutter_slide_competition/dev/domain/repositories/board_management_contract.dart';

class BoardGridUseCases {
  final BoardManagementRepository boardManagementRepository;

  BoardGridUseCases({required this.boardManagementRepository});

  Piece getBasePieceByPosition({required int row, required int col}) {
    return this.boardManagementRepository.getBasePiece(row: row, col: col);
  }

}