// Models
import 'dart:io';

import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/sound.dart';

// Contracts
import 'package:flutter_slide_competition/dev/domain/repositories/sound_management_contract.dart';
import 'package:just_audio/just_audio.dart';

class SoundManagementRepositoryImpl implements SoundManagementRepository {
  late final SoundManager _soundManager;

  SoundManagementRepositoryImpl({required SoundManager soundManager}) {
    this._soundManager = soundManager;
  }

  @override
  void addSlot({required Piece piece}) =>
      this._soundManager.setMusicalPiece(piece: piece);

  @override
  Piece removeLast() => this._soundManager.eraseLastNote();

  @override
  bool isUserSetComplete() => this._soundManager.isUserSetComplete;

  @override
  bool compare() {
    if (this._soundManager.soundPuzzleType == SoundType.CHORD) {
      // Comparing for Chord
      for (int i = 0; i < this._soundManager.templateNotes.length; i++) {
        if (!this
            ._soundManager
            .templateNotes
            .contains(this._soundManager.userNotes[i].musicalNote))
          return false;
      }
      return true;
    } else {
      // Comparing for sequence of notes
      for (int i = 0; i < this._soundManager.templateNotes.length; i++) {
        if (this._soundManager.userNotes[i].musicalNote !=
            this._soundManager.templateNotes[i]) return false;
      }
      return true;
    }
  }

  @override
  int getNumberOccupiedSlots() => this._soundManager.numberSlotsUsed;

  @override
  int getTotalNotes() => this._soundManager.totalNotes;

  String _audioFile({required MusicalNote musicalNote}) {
    String filename;
    switch (musicalNote) {
      case MusicalNote.C:
        filename = 'do';
        break;
      case MusicalNote.D:
        filename = 're';
        break;
      case MusicalNote.E:
        filename = 'mi';
        break;
      case MusicalNote.F:
        filename = 'fa';
        break;
      case MusicalNote.G:
        filename = 'sol';
        break;
      case MusicalNote.A:
        filename = 'la';
        break;
      case MusicalNote.B:
        filename = 'si';
        break;
      case MusicalNote.C8:
        filename = 'do8';
        break;
      default:
        throw Exception(
            'Sound Management Impl: Unknown piece shape has been detected');
    }

    return 'sounds/' + filename + '.wav';
  }

  @override
  Future playSound({
    required Piece piece,
    required AudioPlayer player,
  }) async {
    player.setAsset(this._audioFile(musicalNote: piece.musicalNote));
    player.play();
  }

  @override
  Future playAll(
      {required bool playFromTemplate,
      required List<AudioPlayer> players}) async {
    if (this._soundManager.soundPuzzleType == SoundType.CHORD) {
      // Trying to make sound the notes as quick as possible
      for (int i = 0; i < this._soundManager.templateNotes.length; i++) {
        await players[i].setAsset(
            this._audioFile(
                musicalNote: (playFromTemplate)
                    ? this._soundManager.templateNotes[i]
                    : this._soundManager.userNotes[i].musicalNote),
            preload: true);
      }
      for (int i = 0; i < this._soundManager.templateNotes.length; i++) {
        players[i].play();
      }
    } else {
      // Play notes and delay them a bit
      for (int i = 0; i < this._soundManager.templateNotes.length; i++) {
        await players[i].setAsset(
          this._audioFile(
              musicalNote: (playFromTemplate)
                  ? this._soundManager.templateNotes[i]
                  : this._soundManager.userNotes[i].musicalNote),
        );
        await players[i].play();
        await Future.delayed(Duration(milliseconds: 500));
      }
    }
  }
}
