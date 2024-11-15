import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:book/core/theme/app_colors.dart';
import 'package:book/features/presentation/audio_listening/pages/audio_bottom_widget.dart';
import 'package:book/features/presentation/audio_listening/pages/controls_screen.dart';
import 'package:book/features/presentation/audio_listening/pages/metadata_screen.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

class AudioListeningScreen extends StatefulWidget {
  final AudioSource audioSource;

  const AudioListeningScreen({super.key, required this.audioSource});

  @override
  State<AudioListeningScreen> createState() => _AudioListeningScreenState();
}

class _AudioListeningScreenState extends State<AudioListeningScreen> {
  late AudioPlayer _audioPlayer;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    // _audioPlayer.setAsset("assets/music/nature.mp3");
    // _audioPlayer.setUrl(
    //   "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
    // );
    _init();
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(widget.audioSource);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        clipBehavior: Clip.hardEdge,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              //? Header section
              StreamBuilder<SequenceState?>(
                stream: _audioPlayer.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state!.currentSource!.tag as MediaItem;
                  return BookTitle(
                    imageUrl: metadata.artUri.toString(),
                    title: metadata.artist ?? "",
                    artist: metadata.title,
                  );
                },
              ),

              //? Progress bar
              StreamBuilder(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final postionData = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ProgressBar(
                      barHeight: 5,
                      baseBarColor: AppColors.grey,
                      bufferedBarColor: AppColors.greyLight,
                      progressBarColor: AppColors.primaryColor,
                      thumbRadius: 8,
                      thumbGlowRadius: 20.0,
                      thumbColor: AppColors.primaryColor,
                      timeLabelLocation: TimeLabelLocation.above,
                      timeLabelTextStyle: TextStyle(
                        color: Theme.of(context).textTheme.labelSmall!.color,
                        fontWeight: FontWeight.w400,
                      ),
                      progress: postionData?.position ?? Duration.zero,
                      buffered: postionData?.bufferedPosition ?? Duration.zero,
                      total: postionData?.duration ?? Duration.zero,
                      onSeek: _audioPlayer.seek,
                    ),
                  );
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ControlBar(audioPlayer: _audioPlayer),
              ),

              AudioBottomWidget(audioPlayer: _audioPlayer),
            ],
          ),
        ),
      ),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );
}