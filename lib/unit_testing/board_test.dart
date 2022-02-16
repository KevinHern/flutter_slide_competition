import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/board.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/selected_piece_manager.dart';
import 'package:flutter_slide_competition/dev/data/models/sound.dart';
import 'package:flutter_slide_competition/dev/data/repositories/board_management_impl.dart';
import 'package:flutter_slide_competition/dev/data/repositories/selected_piece_management_impl.dart';
import 'package:flutter_slide_competition/dev/data/repositories/sound_management_impl.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/board_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/dpad_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/selected_piece_usecases.dart';
import 'package:flutter_slide_competition/dev/ui/models/boardUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_board_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/board_grid.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/dpad.dart';
import 'package:provider/provider.dart';

import '../dev/ui/utils/my_utils.dart';

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
        //selectedPieceManager: this.selectedPieceManager,
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
  //final SelectedPieceManager selectedPieceManager;
  final Widget child;

  const BoardProviders({required this.board, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BoardUI>(
          create: (context) => BoardUI(board: board)
        ),
        ChangeNotifierProvider<BoardPieceManagerUI>(
          create: (context) => BoardPieceManagerUI(),
        )
      ],
      child: this.child
    );
  }
}

class BoardTestBody extends StatelessWidget {
  final double scale;
  final SelectedPieceManagementRepository selectedPieceManagementRepository;
  final BoardManagementRepository boardManagementRepository;

  const BoardTestBody({
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

    if (b.puzzlePieces.isNotEmpty) {
      return;
    }

    Piece p = Piece.withDetails(
      rotation: PieceRotation.RIGHT,
      type: PieceType.SPATIAL,
      shape: PieceShape.L,
      location: PieceLocation.BOARD,
    );

    b.addPiece(
      piece: p,
      row: 1,
      col: 1,
    );

    SelectedPieceManagementUseCases(
        selectedPieceManagementRepository: selectedPieceManagementRepository
    ).selectPiece(puzzlePiece: b.puzzlePieces[0]);

    b.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.RIGHT,
        type: PieceType.SPATIAL,
        shape: PieceShape.SQUARE,
        location: PieceLocation.BOARD,
      ),
      row: 4,
      col: 4,
    );

    b.addPiece(
      piece: Piece.withDetails(
        rotation: PieceRotation.UP,
        type: PieceType.SPATIAL,
        shape: PieceShape.LINE,
        location: PieceLocation.BOARD,
      ),
      row: 6,
      col: 6,
    );

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
                selectedManager: selectedPieceManagementRepository,
                soundManagementRepository: SoundManagementRepositoryImpl(
                  soundManager: SoundManager(
                      soundPuzzleType: SoundType.NOTES,
                      template: const [MusicalNote.A, MusicalNote.B, MusicalNote.C]
                  ),
                ),
                boardType: BoardType.SPATIAL,
                moveUp: () => _moveUp(context),
                moveRight: () => _moveRight(context),
                moveDown: () => _moveDown(context),
                moveLeft: () => _moveLeft(context),
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
