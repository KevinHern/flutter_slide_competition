import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/spatial.dart';
import 'package:flutter_slide_competition/dev/data/repositories/bag_management_impl.dart';
import 'package:flutter_slide_competition/dev/data/repositories/spatial_management_impl.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/selected_piece_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/bag_management_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/selected_piece_usecases.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/spatial_management_usecases.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_board_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/selected_spatial_pieceUI.dart';
import 'package:flutter_slide_competition/dev/ui/models/spatialUI.dart';
import 'package:provider/provider.dart';

import '../../../models/bagUI.dart';
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
    // Desactivar rotacion
    Provider.of<ToggleRotation>(context, listen: false).canRotate = false;

    // Actualizar pieza seleccionada
    Provider.of<SelectedPieceManagerUI>(context, listen: false).selectedPiece = piece;
    Provider.of<BoardPieceManagerUI>(context, listen: false).selectedPiece = piece;
    Provider.of<SpatialPieceManagerUI>(context, listen: false).selectedPiece = piece;

    // Se hizo click en tablero, actualizar colores para mostrar pieza seleccionada
    Provider.of<BagUI>(context, listen: false).update();
    Provider.of<BoardUI>(context, listen: false).update();
    Provider.of<SpatialUI>(context, listen: false).update();
  }

  bool movePieceInPuzzle (BuildContext context, int row, int col) {
    BagManagementUseCases bagCases = BagManagementUseCases(
        bagManagementRepository: BagManagementRepositoryImpl(
            bag: Provider.of<BagUI>(context, listen: false).bag
        )
    );

    // obtener pieza
    final Piece piece = selectedCases.getCurrentSelectedPiece();

    // revisar si esta en spatial_board
    if (!piece.isNullPiece && piece.location == PieceLocation.SPATIAL_BOARD) {

      // Remueve del board
      spatialCases.removePieceFromBoard(
          piece: piece
      );

      // Si la posición está ocupada, ya no continuar
      if (!spatialCases.checkIfValidPositionOnBoard(piece: piece, row: row, col: col)) {
        // Agregar a board en el mismo lugar
        spatialCases.addPieceToBoard(
            piece: piece, row: piece.y, col: piece.x
        );

        return false;
      }

      // Agregar a board
      spatialCases.addPieceToBoard(
          piece: piece, row: row, col: col
      );

      checkCorrectness(context);

      return true;
    }

    return false;
  }

  bool addPieceToPuzzle (BuildContext context, int row, int col) {
    BagManagementUseCases bagCases = BagManagementUseCases(
        bagManagementRepository: BagManagementRepositoryImpl(
            bag: Provider.of<BagUI>(context, listen: false).bag
        )
    );

    // obtener pieza
    final Piece piece = selectedCases.getCurrentSelectedPiece();

    // revisar si esta en bolsa
    if (!piece.isNullPiece && piece.location == PieceLocation.BAG) {

      // Si la posición está ocupada, ya no continuar
      if (!spatialCases.checkIfValidPositionOnBoard(piece: piece, row: row, col: col)) {
        return false;
      }

      // Remover de la bolsa
      bagCases.removeFromBag(
          piece: piece
      );

      // Agregar a board
      spatialCases.addPieceToBoard(
          piece: piece, row: row, col: col
      );

      checkCorrectness(context);

      return true;
    }

    return false;
  }

  bool checkCorrectness (BuildContext context) {
    if (spatialCases.isPuzzleCorrect()) {
      Provider.of<UniversalPuzzleToggleManager>(
          context, listen: false
      ).showWinButton = true;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Yey',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            content: Text(
              'Level complete!',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        },
      );
    }

    return spatialCases.isPuzzleCorrect();
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

        // Primero se dibuja el tablero...
        if (targetPiece.isNullPiece) {
          // Casilla sobrante, no se debe colocar pieza aqui
          c = Colors.blueGrey;
        } else {
          // Casillas del puzzle, estas se deben llenar con piezas
          c = Colors.white;
        }

        // Y encima se dibujan las piezas que el jugador ha puesto
        if (!userPiece.isNullPiece) {
          c = userPiece.color;
        }

        Center child = const Center(child: Text(" "));
        // Se coloco pieza en una casilla que debería estar vacía, marcarla con una X
        if (!userPiece.isNullPiece && targetPiece.isNullPiece) {
          child = const Center(
              child: Text(
                "X",
                style: TextStyle(fontSize: 24),
              )
          );
        }

        cuadritos[row * 6 + col] = Container(height: 10, width: 10, color: c, child: child);

        // Pieza seleccionada en color que resalte
        if (userPiece == selPiece && !selPiece.isNullPiece) {
          cuadritos[row * 6 + col] =
              Container(height: 10, width: 10, color: Colors.purpleAccent, child: child);
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

              // Si hay una pieza seleccionada en la bolsa, colocarla
              Piece selPiece = Provider.of<SelectedPieceManagerUI>(context, listen: false).selectedPiece;
              if (selPiece.location == PieceLocation.BAG) {
                if (addPieceToPuzzle(context, row, col)) {
                  // Si se pudo seleccionar la pieza, terminamos
                  updateProvidersAfterClick(context, selPiece);
                  return;
                }
              } else if (selPiece.location == PieceLocation.SPATIAL_BOARD) {
                if (movePieceInPuzzle(context, row, col)) {
                  updateProvidersAfterClick(context, selPiece);
                  return;
                }
              }

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



