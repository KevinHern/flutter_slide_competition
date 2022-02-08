// Models
import 'package:flutter_slide_competition/dev/data/models/bag.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

// Contracts
import 'package:flutter_slide_competition/dev/domain/repositories/bag_management_contract.dart';

class BagManagementUseCases {
  final BagManagementRepository bagManagementRepository;

  BagManagementUseCases({required this.bagManagementRepository});

  void addToBag({required Piece puzzlePiece}) {
    this.bagManagementRepository.addPiece(puzzlePiece: puzzlePiece);
  }

  Piece retrieveFromBag({required int index}) {
    return this.bagManagementRepository.removePiece(index: index);
  }

  void rotatePieceInBag(
      {required Piece puzzlePiece, required PieceRotation newRotation}) {
    this
        .bagManagementRepository
        .rotatePiece(puzzlePiece: puzzlePiece, newRotation: newRotation);
  }
}
