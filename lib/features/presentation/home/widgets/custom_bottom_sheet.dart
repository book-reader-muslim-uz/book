import 'package:book/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomBottomSheet extends StatelessWidget {
  final Function(String) onTap;
  final String selectedCategory;

  const CustomBottomSheet({
    super.key,
    required this.onTap,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> category = [
      {
        "id": "1",
        "title": "book".tr(context: context),
        "image": "book",
      },
      {
        "id": "2",
        "title": "audiobook".tr(context: context),
        "image": "audio_book",
      },
      {
        "id": "3",
        "title": "videobook".tr(context: context),
        "image": "video_book",
      },
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            width: 50,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const Gap(10),
        Container(
          width: double.infinity,
          height: 200, // Increased height to accommodate new option
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 5),
            itemBuilder: (context, index) {
              final item = category[index];
              final isSelected = item['id'] == selectedCategory;

              return ListTile(
                onTap: () {
                  Navigator.pop(context);
                  onTap(item['id']!);
                },
                visualDensity: VisualDensity.compact,
                leading: Image.asset(
                  "assets/images/${item['image']}.png",
                  width: 25,
                  height: 25,
                  fit: BoxFit.cover,
                  color: isSelected ? AppColors.primaryColor : Colors.grey,
                ),
                title: Text(
                  item['title']!,
                  style: TextStyle(
                    color: isSelected ? AppColors.primaryColor : null,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: AppColors.primaryColor,
                      )
                    : null,
              );
            },
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Divider(
                height: 10,
              ),
            ),
            itemCount: category.length,
          ),
        ),
      ],
    );
  }
}
