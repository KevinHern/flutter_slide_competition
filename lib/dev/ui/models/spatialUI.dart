// Basic Imports
import 'package:flutter/material.dart';

// Models
import 'package:flutter_slide_competition/dev/data/models/spatial.dart';

class SpatialUI extends ChangeNotifier {
  late final SpatialManager _spatialModel;

  SpatialUI({required SpatialManager spatialModel}) {
    this._spatialModel = spatialModel;
  }

  SpatialManager get spatialModel => this._spatialModel;

  void update() => notifyListeners();
}