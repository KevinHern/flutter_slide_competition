import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/sound.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/sound_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/sound_management_usecases.dart';
import 'package:flutter_slide_competition/dev/ui/models/sound_slotUI.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/puzzle_piece_icon.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class ButtonsSound extends StatefulWidget {
  late final SoundManagementUseCases soundManagementUseCases;
  ButtonsSound(
      {required SoundManagementRepository soundManagementRepository, Key? key})
      : super(key: key) {
    this.soundManagementUseCases = SoundManagementUseCases(
        soundManagementRepository: soundManagementRepository);
  }

  @override
  _ButtonsSoundState createState() => _ButtonsSoundState();
}

class _ButtonsSoundState extends State<ButtonsSound> {
  late final List<AudioPlayer> audioPlayer;

  @override
  void initState() {
    super.initState();
    this.audioPlayer = [];
    for (int i = 0; i < widget.soundManagementUseCases.getTotalNotes(); i++)
      this.audioPlayer.add(AudioPlayer());
  }

  @override
  void dispose() {
    for (int i = 0; i < widget.soundManagementUseCases.getTotalNotes(); i++)
      this.audioPlayer[i].dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          child: const Text('Play template!'),
          onPressed: () async {
            await widget.soundManagementUseCases.playAll(
              playFromTemplate: true,
              players: this.audioPlayer,
            );
          },
        ),
        ElevatedButton(
          child: const Text('Play my notes!'),
          onPressed: !Provider.of<SoundSlotUI>(context, listen: true)
                  .soundModel
                  .isUserSetComplete
              ? null
              : () async {
                  // --- Actual OnTap Execution --- //
                  await widget.soundManagementUseCases.playAll(
                    playFromTemplate: false,
                    players: this.audioPlayer,
                  );
                },
        ),
      ],
    );
  }
}

class SoundSlotFree extends StatelessWidget {
  final double size;
  const SoundSlotFree({required this.size, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: this.size,
      child: Image.asset('icons/free.png'),
    );
  }
}

class SoundSlot extends StatelessWidget {
  static const double iconSize = 50;

  const SoundSlot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
      child: Consumer<SoundSlotUI>(
        builder: (_, soundSlotUI, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: soundSlotUI.soundModel.userNotes.map(
              (Piece userPiece) {
                return Card(
                  child: (userPiece.musicalNote == MusicalNote.NONE)
                      ? const SoundSlotFree(
                          size: iconSize,
                        )
                      : PieceIcon(size: iconSize, piece: userPiece),
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }
}
