import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class FavoriteNoItems extends StatelessWidget {
  const FavoriteNoItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icons/not.png", width: 150),
          const SizedBox(height: 20),
          Text(
            'no_favorite',
            style: TextStyle(
              color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                  ? Colors.white
                  : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
