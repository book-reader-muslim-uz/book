import 'package:book/core/theme/app_colors.dart';
import 'package:book/features/presentation/settings_screen/pages/about_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    super.key,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late final ValueNotifier<bool> _isDarkModeNotifier;

  @override
  void initState() {
    super.initState();
    _isDarkModeNotifier = ValueNotifier(false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateThemeMode();
    });
  }

  @override
  void dispose() {
    _isDarkModeNotifier.dispose();
    super.dispose();
  }

  void _updateThemeMode() {
    _isDarkModeNotifier.value =
        AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
  }

  void _toggleTheme() {
    AdaptiveTheme.of(context).toggleThemeMode(useSystem: false);
    _isDarkModeNotifier.value = !_isDarkModeNotifier.value;
  }

  Future<void> _changeLanguage(String languageCode) async {
    await context.setLocale(Locale(languageCode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'settings'.tr(context: context),
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(3.0, 3.0),
                    ),
                  ],
                ),
              ),
              background: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.darken,
                child: Image.asset(
                  'assets/images/image.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 20),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isDarkModeNotifier,
                    builder: (context, isDarkMode, child) {
                      return ListTile(
                        leading: Icon(
                          isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          color: AppColors.primaryColor,
                        ),
                        title: Text(
                          isDarkMode
                              ? 'dark_mode'.tr(context: context)
                              : 'light_mode'.tr(context: context),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        trailing: Switch.adaptive(
                          activeColor: AppColors.primaryColor,
                          value: isDarkMode,
                          onChanged: (bool value) => _toggleTheme(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: Icon(
                      Icons.language,
                      color: AppColors.primaryColor,
                    ),
                    title: Text(
                      'languages'.tr(context: context),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    trailing: PopupMenuButton<String>(
                      initialValue: context.locale.languageCode,
                      onSelected: _changeLanguage,
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'en',
                            child: Text('en'.tr(context: context)),
                          ),
                          PopupMenuItem<String>(
                            value: 'ru',
                            child: Text('ru'.tr(context: context)),
                          ),
                          PopupMenuItem<String>(
                            value: 'uz',
                            child: Text('uz'.tr(context: context)),
                          ),
                        ];
                      },
                      offset: const Offset(0, 40),
                      elevation: 2,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.locale.languageCode.tr(context: context),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    },
                    leading: Icon(
                      Icons.info,
                      color: AppColors.primaryColor,
                    ),
                    title: Text(
                      "about_us".tr(context: context),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
