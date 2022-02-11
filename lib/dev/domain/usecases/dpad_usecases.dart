// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/board.dart';

// Contracts
import 'package:flutter_slide_competition/dev/domain/repositories/board_management_contract.dart';

import 'dart:developer';

class DpadUseCases {
  final BoardManagementRepository boardManagementRepository;

  DpadUseCases({required this.boardManagementRepository});

  Piece moveUp({required Piece puzzlePiece}) {
    log("moveUp usecase");
    return this.boardManagementRepository.movePiece(direction: BoardDirection.UP, piece: puzzlePiece);
  }

  Piece moveDown({required Piece puzzlePiece}) {
    log("moveDown usecase");
    return this.boardManagementRepository.movePiece(direction: BoardDirection.DOWN, piece: puzzlePiece);
  }

  Piece moveLeft({required Piece puzzlePiece}) {
    log("moveLeft usecase");
    return this.boardManagementRepository.movePiece(direction: BoardDirection.LEFT, piece: puzzlePiece);
  }

  Piece moveRight({required Piece puzzlePiece}) {
    log("moveRight usecase");
    return this.boardManagementRepository.movePiece(direction: BoardDirection.RIGHT, piece: puzzlePiece);
  }

}
