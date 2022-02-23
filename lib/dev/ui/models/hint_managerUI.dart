// Basic Imports
import 'package:flutter/material.dart';

class HintManager extends ChangeNotifier {
  bool _showMovePieceHint,
      _showChangeToBagHint,
      _showAuditiveHint,
      _showSpatialHint;

  HintManager()
      : this._showMovePieceHint = true,
        this._showChangeToBagHint = true,
        this._showAuditiveHint = true,
        this._showSpatialHint = true;

  void update() => notifyListeners();

  // Setters
  set showMovePieceHint(bool value) => this._showMovePieceHint = value;

  set showChangeToBagHint(bool value) => this._showChangeToBagHint = value;

  set showAuditiveHint(bool value) => this._showAuditiveHint = value;

  set showSpatialHint(bool value) => this._showSpatialHint = value;

  // Getters
  bool get showMovePieceHint => this._showMovePieceHint;
  bool get showChangeToBagHint => this._showChangeToBagHint;
  bool get showAuditiveHint => this._showAuditiveHint;
  bool get showSpatialHint => this._showSpatialHint;
}
