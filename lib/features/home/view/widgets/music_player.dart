import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/utils/color_converter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/current_song_notifier.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            hexToColor(currentSong!.hex_code),
            const Color(0xff121212),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Scaffold(
          backgroundColor: Palette.transparentColor,
          appBar: AppBar(
            backgroundColor: Palette.transparentColor,
            leading: Transform.translate(
              offset: const Offset(-15, 0),
              child: InkWell(
                highlightColor: Palette.transparentColor,
                focusColor: Palette.transparentColor,
                splashColor: Palette.transparentColor,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/pull-down-arrow.png',
                    color: Palette.whiteColor,
                  ),
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Hero(
                    tag: 'music-image',
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            currentSong.thumbnail_url,
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentSong.song_name,
                              style: const TextStyle(
                                color: Palette.whiteColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              currentSong.artist,
                              style: const TextStyle(
                                color: Palette.subtitleText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.heart,
                            color: Palette.whiteColor,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    StreamBuilder(
                        stream: songNotifier.audioPlayer!.positionStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          }
                          final position = snapshot.data;
                          final duration = songNotifier.audioPlayer?.duration;
                          double sliderValue = 0.0;
                          if (position != null && duration != null) {
                            sliderValue = position.inMilliseconds /
                                duration.inMilliseconds;
                          }
                          return Column(
                            children: [
                              StatefulBuilder(
                                builder: (BuildContext context,
                                    void Function(void Function()) setState,) {
                                  return SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                        activeTickMarkColor: Palette.whiteColor,
                                        inactiveTickMarkColor:
                                        Palette.whiteColor.withOpacity(
                                          0.117,
                                        ),
                                        thumbColor: Palette.whiteColor,
                                        trackHeight: 4,
                                        overlayShape:
                                        SliderComponentShape.noOverlay),
                                    child: Slider(
                                      value: sliderValue,
                                      min: 0,
                                      max: 1,
                                      onChanged: (val) {
                                        setState(() {});
                                        sliderValue = val;

                                      },
                                      onChangeEnd: (val) {
                                        setState(() {});
                                        songNotifier.seek(val);
                                      },
                                    ),
                                  );
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${position?.inMinutes}:${(position
                                        ?.inSeconds ?? 0) < 10 ? '0${position
                                        ?.inSeconds}' : position?.inSeconds}',
                                    style: const TextStyle(
                                      color: Palette.subtitleText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    '${duration?.inMinutes}:${(duration
                                        ?.inSeconds ?? 0) < 10 ? '0${duration
                                        ?.inSeconds}' : duration?.inSeconds}',
                                    style: const TextStyle(
                                      color: Palette.subtitleText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          );
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/shuffle.png',
                            color: Palette.whiteColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/previous-song.png',
                            color: Palette.whiteColor,
                          ),
                        ),
                        IconButton(
                          onPressed: songNotifier.playPause,
                          icon: Icon(
                            songNotifier.isPlaying
                                ? CupertinoIcons.pause_circle_fill
                                : CupertinoIcons.play_circle_fill,
                          ),
                          iconSize: 80,
                          color: Palette.whiteColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/next-song.png',
                            color: Palette.whiteColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/repeat.png',
                            color: Palette.whiteColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/connect-device.png',
                            color: Palette.whiteColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/playlist.png',
                            color: Palette.whiteColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
