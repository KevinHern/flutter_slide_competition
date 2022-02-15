// Models
import 'package:flutter_slide_competition/dev/data/models/piece.dart';

// Contracts
import 'package:flutter_slide_competition/dev/domain/repositories/sound_management_contract.dart';
import 'package:just_audio/just_audio.dart';

class SoundManagementUseCases {
  final SoundManagementRepository soundManagementRepository;

  SoundManagementUseCases({required this.soundManagementRepository});

  void addPieceToSlot({required Piece piece}) {
    return this.soundManagementRepository.addSlot(piece: piece);
  }

  Piece removeLastPieceAdded() {
    return this.soundManagementRepository.removeLast();
  }

  bool isUserSetComplete() =>
      this.soundManagementRepository.isUserSetComplete();

  bool isSoundPuzzleComplete() => this.soundManagementRepository.compare();

  int getSlotsUsed() => this.soundManagementRepository.getNumberOccupiedSlots();

  int getTotalNotes() => this.soundManagementRepository.getTotalNotes();

  Future playPieceSound(
          {required AudioPlayer player, required Piece piece}) async =>
      await this
          .soundManagementRepository
          .playSound(player: player, piece: piece);

  Future playAll(
          {required bool playFromTemplate,
          required List<AudioPlayer> players}) async =>
      this
          .soundManagementRepository
          .playAll(playFromTemplate: playFromTemplate, players: players);
}
