import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class TopOverlay extends StatelessWidget {
  const TopOverlay({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      left: 10,
      child: AnimatedContainer(
        width: 50,
        duration: const Duration(milliseconds: 700),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                  ? Colors.grey[800]!
                  : Colors.black.withOpacity(.5),
              blurRadius: 20,
              offset: const Offset(1, 1),
            )
          ],
          color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
              ? Colors.grey[850]
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        height: 50,
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
