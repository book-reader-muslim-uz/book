import 'package:book/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';

class ControlBar extends StatelessWidget {
  const ControlBar({
    super.key,
    required this.audioPlayer,
  });

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //? Backward 15 second
        StreamBuilder<Duration>(
          stream: audioPlayer.positionStream,
          builder: (context, snapshot) {
            final currentPosition = snapshot.data ?? Duration.zero;
            return IconButton(
              onPressed: () {
                final newPosition =
                    currentPosition - const Duration(seconds: 15);
                if (newPosition.inSeconds >= 0) {
                  audioPlayer.seek(newPosition);
                } else {
                  audioPlayer.seek(Duration.zero);
                }
              },
              icon: SvgPicture.asset(
                "assets/svgs/backward_seconds.svg",
                height: 35,
                width: 35,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).textTheme.titleLarge!.color!,
                  BlendMode.srcIn,
                ),
              ),
            );
          },
        ),

        //? Play and Pausa
        Container(
          alignment: Alignment.center,
          width: 86.0,
          height: 86.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(37),
            color: AppColors.primaryColor.withOpacity(0.2),
          ),
          child: Container(
            alignment: Alignment.center,
            width: 74.0,
            height: 74.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(37),
              color: AppColors.primaryColor,
            ),
            child: StreamBuilder<PlayerState?>(
              stream: audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (!(playing ?? false)) {
                  return IconButton(
                    onPressed: audioPlayer.play,
                    color: AppColors.white,
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                      size: 55,
                    ),
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    onPressed: audioPlayer.pause,
                    // iconSize: 80,
                    color: AppColors.white,
                    icon: const Icon(
                      Icons.pause_rounded,
                      size: 55,
                    ),
                  );
                }
                return const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.black,
                  size: 80,
                );
              },
            ),
          ),
        ),

        //? forward 15 second
        StreamBuilder<Duration>(
          stream: audioPlayer.positionStream,
          builder: (context, snapshot) {
            final currentPosition = snapshot.data ?? Duration.zero;
            return IconButton(
              onPressed: () {
                final newPosition =
                    currentPosition + const Duration(seconds: 15);
                if (newPosition.inSeconds >= 0) {
                  audioPlayer.seek(newPosition);
                } else {
                  audioPlayer.seek(Duration.zero);
                }
              },
              icon: SvgPicture.asset(
                height: 35,
                width: 35,
                "assets/svgs/forward_seconds.svg",
                colorFilter: ColorFilter.mode(
                  Theme.of(context).textTheme.titleLarge!.color!,
                  BlendMode.srcIn,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}