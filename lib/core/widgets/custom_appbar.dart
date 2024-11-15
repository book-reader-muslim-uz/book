import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      forceMaterialTransparency: true,
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "book".tr(context: context),
              style: TextStyle(
                color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: "collection".tr(context: context),
              style: const TextStyle(
                color: Color(0xffD1618A),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
