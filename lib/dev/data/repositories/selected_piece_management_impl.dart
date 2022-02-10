// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/selected_piece_manager.dart';

// Contracts
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';

class PieceManagementRepositoryImpl
    implements SelectedPieceManagementRepository {
  late final SelectedPieceManager _selectedPieceManager;

  PieceManagementRepositoryImpl(
      {required SelectedPieceManager selectedPieceManager}) {
    this._selectedPieceManager = selectedPieceManager;
  }

  @override
  Piece getSelectedPiece() {
    return this._selectedPieceManager.getSelectedPiece();
  }

  @override
  void selectPiece({required Piece piece}) {
    //unselectWhenNewIsSelected();
    this._selectedPieceManager.updateSelectedPiece(piece: piece);
  }

  @override
  int unselectWhenNewIsSelected() {
    return this._selectedPieceManager.unselectSelectedPiece();
  }
}
