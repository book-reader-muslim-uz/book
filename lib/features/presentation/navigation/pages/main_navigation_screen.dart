import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:book/core/theme/app_colors.dart';
import 'package:book/features/presentation/home/pages/home_page.dart';
import 'package:book/features/presentation/navigation/cubit/navigation_cubit.dart';
import 'package:book/features/presentation/favorite_screen/screens/favorite_screen.dart';
import 'package:book/features/presentation/settings_screen/pages/setting_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});
  static List<Widget> pages = [
    const HomePage(),
    const FavoriteScreen(),
    const SettingScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<NavigationCubit, int>(
            builder: (context, state) {
              return LazyLoadIndexedStack(index: state, children: pages);
            },
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items = [
      {
        "icon": {"active": "home"},
        "label": "book".tr(context: context)
      },
      {
        "icon": {"active": "favourite_book"},
        "label": "favorites".tr(context: context)
      },
      {
        "icon": {"active": "settings"},
        "label": "settings".tr(context: context)
      },
    ];
    final isDarkMode = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;

    return BottomNavigationBar(
      currentIndex: context.watch<NavigationCubit>().state,
      onTap: (index) {
        try {
          context.read<NavigationCubit>().changePage(index);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Xatolik yuz berdi: $e')),
          );
        }
      },
      items: items.map((item) {
        return BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/svgs/${item['icon']['active']}.svg",
            width: 25,
            height: 25,
          ),
          activeIcon: SvgPicture.asset(
            "assets/svgs/${item['icon']['active']}.svg",
            width: 25,
            height: 25,
            colorFilter:
                ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
          ),
          label: item['label'],
        );
      }).toList(),
      selectedItemColor: AppColors.primaryColor,
      // unselectedItemColor: isDarkMode ? Colors.grey : AppColors.primaryColor,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor:
          isDarkMode ? const Color.fromARGB(78, 0, 0, 0) : Colors.white,
    );
  }
}
