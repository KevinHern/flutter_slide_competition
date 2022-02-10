// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

// Contracts
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';

class SelectedPieceManagementUseCases {
  final SelectedPieceManagementRepository selectedPieceManagementRepository;

  SelectedPieceManagementUseCases(
      {required this.selectedPieceManagementRepository});

  Piece getCurrentSelectedPiece() {
    return this.selectedPieceManagementRepository.getSelectedPiece();
  }

  void selectPiece({required Piece puzzlePiece}) {
    this.selectedPieceManagementRepository.selectPiece(piece: puzzlePiece);
  }

  int unselectPiece() {
    return this.selectedPieceManagementRepository.unselectWhenNewIsSelected();
  }
}
