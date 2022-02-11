import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/board.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/selected_piece_manager.dart';
import 'package:flutter_slide_competition/dev/data/repositories/board_management_impl.dart';
import 'package:flutter_slide_competition/dev/data/repositories/selected_piece_management_impl.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/board_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/dpad_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/selected_piece_usecases.dart';
import 'package:flutter_slide_competition/dev/ui/models/boardUI.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/board_grid.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/dpad.dart';
import 'package:provider/provider.dart';

import '../dev/ui/utils/my_utils.dart';

import 'dart:developer';

class BoardTestScreen extends StatelessWidget {
  final double scale;
  final double height = 40, width = 40;
  final double padding = 5;

  // que repos necesito?
  late final BoardManagementRepository boardManagementRepository;
  late final SelectedPieceManagementRepository selectedPieceManagementRepository;

  // que modelos necesito?
  final Board board = Board();
  late final SelectedPieceManager selectedPieceManager;

  BoardTestScreen({required this.scale, Key? key}) : super(key: key) {
    selectedPieceManager = SelectedPieceManager(puzzlePieces: board.puzzlePieces);

    boardManagementRepository = BoardManagementRepositoryImpl(board: board);
    selectedPieceManagementRepository = PieceManagementRepositoryImpl(selectedPieceManager: selectedPieceManager);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BoardProviders(
        board: this.board,
        selectedPieceManager: this.selectedPieceManager,
        child: BoardTestBody(
          scale: 2.5,
          selectedPieceManagementRepository: selectedPieceManagementRepository,
          boardManagementRepository: boardManagementRepository,
        ),
      ),
    );
  }
}

class BoardProviders extends StatelessWidget {
  final Board board;
  final SelectedPieceManager selectedPieceManager;
  final Widget child;

  const BoardProviders({required this.board, required this.selectedPieceManager, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BoardUI>(
          create: (context) => BoardUI(board: board)
        ),

        // ChangeNotifierProvider<SelectedPieceManagerUI>(
        //   create: (context) => SelectedPieceManagerUI(),
        // ),
      ],
      child: this.child
    );
  }
}

class BoardTestBody extends StatelessWidget {
  final double scale;
  final SelectedPieceManagementRepository selectedPieceManagementRepository;
  final BoardManagementRepository boardManagementRepository;

  const BoardTestBody(
      {
        required this.scale,
        required this.selectedPieceManagementRepository,
        required this.boardManagementRepository,
        Key? key
      }) : super(key: key);

  void _moveUp(BuildContext context) {
    final Piece piece = SelectedPieceManagementUseCases(
        selectedPieceManagementRepository:selectedPieceManagementRepository
    ).getCurrentSelectedPiece();

    DpadUseCases(
        boardManagementRepository: boardManagementRepository
    ).moveUp(puzzlePiece: piece);

    Provider.of<BoardUI>(context, listen: false).update();
  }

  void _moveDown(BuildContext context) {
    final Piece piece = SelectedPieceManagementUseCases(
        selectedPieceManagementRepository:selectedPieceManagementRepository
    ).getCurrentSelectedPiece();

    DpadUseCases(
        boardManagementRepository: boardManagementRepository
    ).moveDown(puzzlePiece: piece);

    Provider.of<BoardUI>(context, listen: false).update();
  }

  void _moveLeft(BuildContext context) {
    final Piece piece = SelectedPieceManagementUseCases(
        selectedPieceManagementRepository:selectedPieceManagementRepository
    ).getCurrentSelectedPiece();

    DpadUseCases(
        boardManagementRepository: boardManagementRepository
    ).moveLeft(puzzlePiece: piece);

    Provider.of<BoardUI>(context, listen: false).update();
  }

  void _moveRight(BuildContext context) {
    final Piece piece = SelectedPieceManagementUseCases(
        selectedPieceManagementRepository:selectedPieceManagementRepository
    ).getCurrentSelectedPiece();

    DpadUseCases(
        boardManagementRepository: boardManagementRepository
    ).moveRight(puzzlePiece: piece);

    Provider.of<BoardUI>(context, listen: false).update();
  }

  void _addPieceTest(BuildContext context) {
    Board b = Provider.of<BoardUI>(context, listen: false).board;
    Piece p = Piece.withDetails(
      rotation: PieceRotation.RIGHT,
      type: PieceType.SPATIAL,
      shape: PieceShape.L,
      location: PieceLocation.BOARD,
    );

    b.addPiece(
      piece: p,
      row: 4,
      col: 5,
    );

    SelectedPieceManagementUseCases(
        selectedPieceManagementRepository: selectedPieceManagementRepository
    ).selectPiece(puzzlePiece: b.puzzlePieces[0]);

    //Provider.of<BoardUI>(context, listen: false).update();
  }

  @override
  Widget build(BuildContext context ) {
    _addPieceTest(context);

    return Padding(
      padding: MyUtils.setScreenPadding(context: context),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BoardGrid(
                board: Provider.of<BoardUI>(context, listen: true).board,
              ),
              DPad(
                scale: scale,
                isActive: true,
                upPress: () => _moveUp(context),
                rightPress: () => _moveRight(context),
                downPress: () => _moveDown(context),
                leftPress: () => _moveLeft(context),
              ),
            ],
          ),
        ),
      ),
    );
  }}


                  // // TODO: Quitar estas piezas, agregadas solo para probar
                  // boardUI.board.addPiece(
                  //     piece: Piece.withDetails(
                  //         rotation: PieceRotation.UP,
                  //         type: PieceType.SPATIAL,
                  //         shape: PieceShape.DOT,
                  //         location: PieceLocation.BOARD),
                  //     row: 1,
                  //     col: 1);
                  // boardUI.board.addPiece(
                  //     piece: Piece.withDetails(
                  //         rotation: PieceRotation.UP,
                  //         type: PieceType.SPATIAL,
                  //         shape: PieceShape.DOT,
                  //         location: PieceLocation.BOARD),
                  //     row: 0,
                  //     col: 0);
                  // boardUI.board.addPiece(
                  //     piece: Piece.withDetails(
                  //         rotation: PieceRotation.UP,
                  //         type: PieceType.SPATIAL,
                  //         shape: PieceShape.SQUARE,
                  //         location: PieceLocation.BOARD),
                  //     row: 1,
                  //     col: 1);
                  // boardUI.board.addPiece(
                  //     piece: Piece.withDetails(
                  //         rotation: PieceRotation.UP,
                  //         type: PieceType.SPATIAL,
                  //         shape: PieceShape.LINE,
                  //         location: PieceLocation.BOARD),
                  //     row: 0,
                  //     col: 4);
                  // boardUI.board.addPiece(
                  //     piece: Piece.withDetails(
                  //         rotation: PieceRotation.LEFT,
                  //         type: PieceType.SPATIAL,
                  //         shape: PieceShape.LINE,
                  //         location: PieceLocation.BOARD),
                  //     row: 0,
                  //     col: 7);
                  // boardUI.board.addPiece(
                  //     piece: Piece.withDetails(
                  //         rotation: PieceRotation.UP,
                  //         type: PieceType.SPATIAL,
                  //         shape: PieceShape.L,
                  //         location: PieceLocation.BOARD),
                  //     row: 5,
                  //     col: 0);
                  // boardUI.board.addPiece(
                  //     piece: Piece.withDetails(
                  //         rotation: PieceRotation.DOWN,
                  //         type: PieceType.SPATIAL,
                  //         shape: PieceShape.L,
                  //         location: PieceLocation.BOARD),
                  //     row: 4,
                  //     col: 1);
                  // boardUI.board.addPiece(
                  //     piece: Piece.withDetails(
                  //         rotation: PieceRotation.RIGHT,
                  //         type: PieceType.SPATIAL,
                  //         shape: PieceShape.L,
                  //         location: PieceLocation.BOARD),
                  //     row: 4,
                  //     col: 5);
                  // boardUI.board.addPiece(
                  //     piece: Piece.withDetails(
                  //         rotation: PieceRotation.LEFT,
                  //         type: PieceType.SPATIAL,
                  //         shape: PieceShape.L,
                  //         location: PieceLocation.BOARD),
                  //     row: 5,
                  //     col: 6);
                  // // TODO: Quitar estas piezas, agregadas solo para probar