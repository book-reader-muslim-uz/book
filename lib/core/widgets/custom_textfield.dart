import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final IconData? icon;
  final Function()? onTap;
  final bool readOnly;
  const CustomTextfield({
    super.key,
    this.readOnly = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        fillColor: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
            ? Colors.grey[800]
            : Colors.grey[250],
        filled: true,
        suffixIcon: GestureDetector(
          onTap: onTap,
          child: Icon(icon),
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(Icons.search_rounded),
          // child: Image.asset(
          //   "assets/icons/search.png",
          //   width: 24,
          //   height: 24,
          //   color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
          //       ? Colors.grey
          //       : Colors.black,
          // ),
        ),
        hintText: "search".tr(context: context),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
