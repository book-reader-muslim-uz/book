import 'package:book/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final Function(String) onTap;
  final String selectedCategory;

  CustomBottomSheet({
    super.key,
    required this.onTap,
    required this.selectedCategory,
  });

  final List<Map<String, String>> _category = [
    {
      "id": "1",
      "title": "book".tr(),
      "image": "book",
    },
    {
      "id": "2",
      "title": "audiobook".tr(),
      "image": "audio_book",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 5),
        Center(
          child: Container(
            width: 50,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 140,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 5),
            itemBuilder: (context, index) {
              final item = _category[index];
              final isSelected = item['id'] == selectedCategory;

              return ListTile(
                onTap: () {
                  Navigator.pop(context);
                  onTap(item['id']!);
                },
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
              child: Divider(),
            ),
            itemCount: _category.length,
          ),
        ),
      ],
    );
  }
}
