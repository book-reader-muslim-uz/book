import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CacheImage extends StatelessWidget {
  const CacheImage({
    super.key,
    required this.imageUrl,  
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imageUrl,
      width: double.infinity,
      scale: 1,
      height: 150,
      alignment: Alignment.center,
      fadeInCurve: Curves.linear,
      fadeInDuration: const Duration(milliseconds: 500),
      placeholder: (context, url) {
        return Shimmer.fromColors(
          baseColor: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
              ? Colors.grey[700]!
              : Colors.grey[300]!,
          highlightColor:
              AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                  ? Colors.grey[500]!
                  : Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: 170,
            color: Colors.white,
          ),
        );
      },
      errorWidget: (context, url, error) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Image.asset("assets/images/error.png"),
      ),
    );
  }
}
