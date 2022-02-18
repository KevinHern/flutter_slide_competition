import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/spatial.dart';
import 'package:flutter_slide_competition/dev/data/repositories/board_management_impl.dart';
import 'package:flutter_slide_competition/dev/data/repositories/spatial_management_impl.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/spatial_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/board_grid_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/selected_piece_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/spatial_management_usecases.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_board_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_spatial_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/spatialUI.dart';
import 'package:provider/provider.dart';

import '../../../models/boardUI.dart';
import '../../../models/selected_pieceUI.dart';
import '../../../models/toggle_managerUI.dart';

/* Stateless: no necesita state porque no hay nada relacionado con audio */
class SpatialGrid extends StatelessWidget {
  final SpatialManager spatialManager;
  final SelectedPieceManagementRepository selectedManager;

  late final SpatialManagementUseCases spatialCases;
  late final SelectedPieceManagementUseCases selectedCases;


  SpatialGrid({
    required this.spatialManager,
    required this.selectedManager,
    Key? key,
  }) : super(key: key) {
    selectedCases = SelectedPieceManagementUseCases(
      selectedPieceManagementRepository: selectedManager
    );

    spatialCases = SpatialManagementUseCases(
      spatialManagementRepository: SpatialManagementRepositoryImpl(
          model: spatialManager
      )
    );
  }

  Piece selectPieceOnClick(int row, int col) {
    // Una pieza puede ocupar varias casillas
    // Obtiene la pieza base
    Piece piece = spatialCases.getBasePieceByPosition(row: row, col: col);

    if (piece.isNullPiece) {
      // Si fue una casilla vacía
      // Deseleccionar
      selectedCases.unselectPiece();
    } else {
      // Si fue una pieza válida
      // Seleccionar
      selectedCases.selectPiece(puzzlePiece: piece);
    }

    return piece;
  }

  void updateProvidersAfterClick (BuildContext context, Piece piece) {
    // bag
    Provider.of<ToggleRotation>(context, listen: false).canRotate = false;
    Provider.of<SelectedPieceManagerUI>(context, listen: false).selectPiece = piece;

    // board
    Provider.of<BoardPieceManagerUI>(context, listen: false).selectedPiece = piece;
    Provider.of<BoardUI>(context, listen: false).update();

    // spatial
    Provider.of<SpatialPieceManagerUI>(context, listen: false).selectedPiece = piece;
    Provider.of<SpatialUI>(context, listen: false).update();
  }

  @override
  Widget build(BuildContext context) {
    Piece selPiece = Provider.of<BoardPieceManagerUI>(context, listen: false).selectedPiece;

    // Lista de 36 casillas representando al board
    List<Container> cuadritos = List.generate(36, (_) => Container());

    for (int row = 0; row < 6; row++) {
      for (int col = 0; col < 6; col++) {
        Piece targetPiece = spatialManager.targetBoard[row][col];
        Piece userPiece = spatialManager.userBoard[row][col];

        Color c = Colors.grey;

        if (targetPiece.isNullPiece) {
          c = Colors.blueGrey;
        } else {
          c = Colors.lightBlueAccent;
        }

        if (!userPiece.isNullPiece) {
          c = userPiece.color;
        }

        cuadritos[row*6 + col] = Container(height: 10, width: 10, color: c);

        if (userPiece == selPiece) {
          cuadritos[row * 6 + col] = Container(height: 10, width: 10, color: Colors.purpleAccent);
        }
      }
    }

    return Container(
      color: Colors.white,
      width: 300,
      height: 300,
      child: GridView.count(
        crossAxisCount: 6,
        children: [
          for(var item in cuadritos) GestureDetector(

            // Se hizo click en alguna casilla del tablero
            onTap: () {
              // Obtener fila y columna
              int index = cuadritos.indexOf(item);
              int row = index ~/ 6;
              int col = index % 6;

              print("spatial grid: x = $col - y = $row");

              Piece piece = selectPieceOnClick(row, col);
              updateProvidersAfterClick(context, piece);
            },
            child: item,
          )
        ],
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
    );
  }
}



