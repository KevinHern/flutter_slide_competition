// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:just_audio/just_audio.dart';

abstract class SoundManagementRepository {
  void addSlot({required Piece piece});
  Piece removeLast();
  bool isUserSetComplete();
  bool compare();
  int getNumberOccupiedSlots();
  int getTotalNotes();
  Future playSound({required Piece piece, required AudioPlayer player});
  Future playAll(
      {required bool playFromTemplate, required List<AudioPlayer> players});
}
