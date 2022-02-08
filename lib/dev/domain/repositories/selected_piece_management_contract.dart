// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

abstract class SelectedPieceManagementRepository {
  // Activar flag de selección de piezas
  // Refrescar UI
  void selectPiece ({required Piece piece});

  // Pieza anteriormente seleccionada deja de estarlo
  int unselectWhenNewIsSelected ();

  // Obtiene referencia a la pieza seleccionada
  Piece getSelectedPiece ();
}