import 'package:flutter/material.dart';

class HintManager extends ChangeNotifier {
  bool _showMovePieceHint,
      _showChangeToBagHint,
      _showAuditiveHint,
      _showSpatialHint,
      _showClickOnChangeButton,
      _showClickOnBagPiece,
      _showClickOnAddButton,
      _showClickOnSpatialBoard;

  HintManager()
      : this._showMovePieceHint = true,
        this._showChangeToBagHint = true,
        this._showAuditiveHint = true,
        this._showSpatialHint = true,
        this._showClickOnChangeButton = false,
        this._showClickOnBagPiece = false,
        this._showClickOnAddButton = false,
        this._showClickOnSpatialBoard = false;

  void update() => notifyListeners();

  // Setters
  set showMovePieceHint(bool value) => this._showMovePieceHint = value;
  set showChangeToBagHint(bool value) => this._showChangeToBagHint = value;
  set showAuditiveHint(bool value) => this._showAuditiveHint = value;
  set showSpatialHint(bool value) => this._showSpatialHint = value;
  set showClickOnChangeButton(bool value) => this._showClickOnChangeButton = value;
  set showClickOnBagPiece (bool value) => this._showClickOnBagPiece = value;
  set showClickOnAddButton (bool value) => this._showClickOnAddButton = value;
  set showClickOnSpatialBoard (bool value) => this._showClickOnSpatialBoard = value;

  // Getters
  bool get showMovePieceHint => this._showMovePieceHint;
  bool get showChangeToBagHint => this._showChangeToBagHint;
  bool get showAuditiveHint => this._showAuditiveHint;
  bool get showSpatialHint => this._showSpatialHint;
  bool get showClickOnChangeButton => this._showClickOnChangeButton;
  bool get showClickOnBagPiece => this._showClickOnBagPiece;
  bool get showClickOnAddButton => this._showClickOnAddButton;
  bool get showClickOnSpatialBoard => this._showClickOnSpatialBoard;
}
