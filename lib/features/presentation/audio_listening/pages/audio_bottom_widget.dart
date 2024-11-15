import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:book/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:book/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';

class AudioBottomWidget extends StatefulWidget {
  final AudioPlayer audioPlayer;

  const AudioBottomWidget({
    super.key,
    required this.audioPlayer,
  });

  @override
  State<AudioBottomWidget> createState() => _AudioBottomWidgetState();
}

class _AudioBottomWidgetState extends State<AudioBottomWidget> {
  Timer? _timer;
  int _remainingSeconds = 0;

  void _showTimerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(10),
              ListTile(
                title: Text('no_timer'.tr(context: context)),
                onTap: () {
                  Navigator.pop(context);
                  _cancelTimer();
                },
              ),
              _buildTimerListTile(context, 1),
              _buildTimerListTile(context, 15),
              _buildTimerListTile(context, 30),
            ],
          ),
        );
      },
    );
  }

  ListTile _buildTimerListTile(BuildContext context, int minutes) {
    return ListTile(
      title: Text('$minutes ${'minutes'.tr(context: context)}'),
      onTap: () {
        Navigator.pop(context);
        _startTimer(minutes);
      },
    );
  }

  void _startTimer(int minutes) {
    _cancelTimer();
    _remainingSeconds = minutes * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _cancelTimer();
          _stopMusic();
        }
      });
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _remainingSeconds = 0;
    });
  }

  void _stopMusic() {
    widget.audioPlayer.stop();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showSpeedSheet(BuildContext context) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (context) {
        double playbackSpeed = widget.audioPlayer.speed;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    'playback_speed'
                        .tr(context: context)
                        .replaceAll('{}', playbackSpeed.toStringAsFixed(1)),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.titleLarge!.color,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Slider(
                  activeColor: AppColors.primaryColor,
                  thumbColor: AppColors.primaryColor,
                  value: playbackSpeed,
                  onChanged: (newSpeed) {
                    setState(() {
                      playbackSpeed = newSpeed;
                    });
                  },
                  min: 0.5,
                  max: 2.0,
                  divisions: 6,
                  label: playbackSpeed.toStringAsFixed(1),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('0.5x'),
                    Text('0.8x'),
                    Text('1.0x'),
                    Text('1.3x'),
                    Text('1.5x'),
                    Text('1.8x'),
                    Text('2.0x'),
                  ],
                ),
                const Gap(20.0),
                AppButton(
                  text: "done".tr(context: context),
                  color: AppColors.primaryColor,
                  onTap: () {
                    widget.audioPlayer.setSpeed(playbackSpeed);
                    Navigator.pop(context);
                  },
                ),
                const Gap(30.0),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_remainingSeconds > 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '${'music_stop_in'.tr(context: context)} ${_formatTime(_remainingSeconds)}',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => _showTimerSheet(context),
                child: SizedBox(
                  height: 84,
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        height: 30,
                        width: 30,
                        "assets/svgs/moon_rounded.svg",
                        colorFilter: ColorFilter.mode(
                          AdaptiveTheme.of(context).mode ==
                                  AdaptiveThemeMode.dark
                              ? AppColors.greyLight
                              : AppColors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                      const Gap(5.0),
                      Text(
                        "sleep_timer".tr(context: context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AdaptiveTheme.of(context).mode ==
                                  AdaptiveThemeMode.dark
                              ? AppColors.greyLight
                              : AppColors.grey.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => _showSpeedSheet(context),
                child: SizedBox(
                  height: 84,
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/svgs/linear_x.svg",
                        height: 30,
                        width: 30,
                        colorFilter: ColorFilter.mode(
                          AdaptiveTheme.of(context).mode ==
                                  AdaptiveThemeMode.dark
                              ? AppColors.greyLight
                              : AppColors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                      const Gap(5.0),
                      Text(
                        "speed".tr(context: context),
                        style: TextStyle(
                          color: AdaptiveTheme.of(context).mode ==
                                  AdaptiveThemeMode.dark
                              ? AppColors.greyLight
                              : AppColors.grey.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}

class AppButton extends StatelessWidget {
  final String text;
  final Color color;
  final int? n;
  final Function() onTap;
  const AppButton({
    super.key,
    this.n,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 340,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: n == 1 ? const Color(0xFF0A982F) : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
