import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class BottomOverlay extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<double> onSliderChange;

  const BottomOverlay({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onSliderChange,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 10,
      right: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
              ? Colors.grey[850]
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                  ? Colors.grey[800]!
                  : Colors.black.withOpacity(.5),
              blurRadius: 20,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Slider(
              activeColor: const Color(0xff0A982F),
              value: currentPage.toDouble(),
              max: totalPages.toDouble(),
              onChanged: onSliderChange,
            ),
            Text(
              '$currentPage / $totalPages',
              style: TextStyle(
                color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
