import 'package:client/features/home/model/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? audioPlayer;
  bool isPlaying = false;

  @override
  SongModel? build() {
    return null;
  }

  void updateSong(SongModel song) async {
    audioPlayer = AudioPlayer();
    await audioPlayer!.setUrl(song.song_url);
    final audioSource = AudioSource.uri(
      Uri.parse(song.song_url),
    );
    await audioPlayer!.setAudioSource(audioSource);
    audioPlayer!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        audioPlayer!.seek(Duration.zero);
        audioPlayer!.pause();
        isPlaying = false;
        // huh here we only update the state for make the riverbod to rebuild the widget for make the play pause button to change
        this.state = this.state?.copyWith(hex_code: this.state?.hex_code);
      }
    });
    audioPlayer!.play();
    isPlaying = true;
    state = song;
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }
    isPlaying = !isPlaying;
    // huh here we only update the state for make the riverbod to rebuild the widget for make the play pause button to change
    state = state?.copyWith(hex_code: state?.hex_code);
  }
}
