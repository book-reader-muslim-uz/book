import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerLoading(BuildContext context) {
  return SingleChildScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Shimmer.fromColors(
          baseColor: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
              ? Colors.grey[700]!
              : Colors.grey[300]!,
          highlightColor:
              AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                  ? Colors.grey[500]!
                  : Colors.grey[100]!,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  List.generate(5, (index) => _buildShimmerCategoryButton()),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Shimmer.fromColors(
            baseColor: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                ? Colors.grey[700]!
                : Colors.grey[300]!,
            highlightColor:
                AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                    ? Colors.grey[500]!
                    : Colors.grey[100]!,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: 6,
              itemBuilder: (context, index) => _buildShimmerBookItem(),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildShimmerCategoryButton() {
  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: Container(
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}

Widget _buildShimmerBookItem() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
  );
}
