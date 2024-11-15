import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FavoriteNoItems extends StatelessWidget {
  const FavoriteNoItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/not.png", width: 150),
          const SizedBox(height: 20),
          Text(
            'no_favorite'.tr(context: context),
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
