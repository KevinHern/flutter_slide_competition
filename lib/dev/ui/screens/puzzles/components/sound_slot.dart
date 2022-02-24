import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/data/models/piece.dart';
import 'package:flutter_slide_competition/dev/data/models/sound.dart';
import 'package:flutter_slide_competition/dev/domain/repositories/sound_management_contract.dart';
import 'package:flutter_slide_competition/dev/domain/usecases/sound_management_usecases.dart';
import 'package:flutter_slide_competition/dev/ui/models/sound_slotUI.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/puzzle_button.dart';
import 'package:flutter_slide_competition/dev/ui/screens/puzzles/components/puzzle_piece_icon.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class ButtonsSound extends StatefulWidget {
  final double scale;
  late final SoundManagementUseCases soundManagementUseCases;
  ButtonsSound(
      {required SoundManagementRepository soundManagementRepository,
      this.scale = 1.25,
      Key? key})
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
        IconPuzzleButton(
          scale: widget.scale,
          icon: 'sound',
          text: 'Play Template!',
          onPressed: () async {
            await widget.soundManagementUseCases.playAll(
              playFromTemplate: true,
              players: this.audioPlayer,
            );
          },
        ),
        const SizedBox(
          width: 15,
        ),
        IconPuzzleButton(
          scale: widget.scale,
          icon: 'sound',
          text: 'Play my Notes!',
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
  final double width, scale, elevation, cardRadius, cardPadding;
  final Color cardColor, cardBorderColor;
  static const double iconSize = 50;

  const SoundSlot(
      {required this.scale,
      this.width = 500,
      this.elevation = 10.0,
      this.cardRadius = 8.0,
      this.cardPadding = 8.0,
      this.cardColor = const Color(0xFFfce4c4),
      this.cardBorderColor = const Color(0xFFe3b983),
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: this.width,
      child: Card(
        elevation: this.elevation,
        color: this.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(this.cardRadius),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              width: 5,
              color: this.cardBorderColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(this.cardRadius)),
          ),
          child: Padding(
            padding: EdgeInsets.all(this.cardPadding),
            child: Consumer<SoundSlotUI>(
              builder: (_, soundSlotUI, __) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: soundSlotUI.soundModel.userNotes.map(
                    (Piece userPiece) {
                      return Card(
                        elevation: this.elevation,
                        child: (userPiece.musicalNote == MusicalNote.NONE)
                            ? SoundSlotFree(
                                size: iconSize * this.scale,
                              )
                            : PieceIcon(
                                size: iconSize * this.scale, piece: userPiece),
                      );
                    },
                  ).toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
