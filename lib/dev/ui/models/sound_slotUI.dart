import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/sound.dart';

class SoundSlotUI extends ChangeNotifier {
  late final SoundManager _soundModel;

  SoundSlotUI({required SoundManager sound}) {
    this._soundModel = sound;
  }

  // Getters
  SoundManager get soundModel => this._soundModel;

  void update() => notifyListeners();
}
