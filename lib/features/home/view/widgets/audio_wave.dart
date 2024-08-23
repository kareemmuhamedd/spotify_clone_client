import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  final String path;

  const AudioWave({
    super.key,
    required this.path,
  });

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final PlayerController playerController = PlayerController();

  void initAudioPlayer() async {
    await playerController.preparePlayer(
      path: widget.path,
    );
  }

  @override
  void initState() {
    initAudioPlayer();
    super.initState();
  }

  Future<void> playAndPause() async {
    if (!playerController.playerState.isPlaying) {
      await playerController.startPlayer(finishMode: FinishMode.stop);
    } else if (!playerController.playerState.isPaused) {
      await playerController.pausePlayer();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: playAndPause,
          icon: Icon(
            playerController.playerState.isPlaying
                ? CupertinoIcons.pause_solid
                : CupertinoIcons.play_arrow_solid,
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AudioFileWaveforms(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Palette.gradient1,
                    Palette.gradient2,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              size: const Size(double.infinity, 100),
              playerController: playerController,
              playerWaveStyle: PlayerWaveStyle(
                fixedWaveColor: Palette.borderColor.withOpacity(0.3),
                liveWaveColor: Colors.white,
                spacing: 4,
                waveThickness: 3,
                showSeekLine: false,
                waveCap: StrokeCap.round,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
