import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptnzzn_random/constants/app_color.dart';
import 'package:ptnzzn_random/constants/app_theme.dart';
import 'package:ptnzzn_random/logic/theme/theme_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    void showThemeChangeDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "theme.label".tr(),
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton(
                    segments: [
                      ButtonSegment(
                        value: AppThemeMode.system,
                        label: Text('theme.system'.tr()),
                      ),
                      ButtonSegment(
                        value: AppThemeMode.light,
                        label: Text('theme.light'.tr()),
                      ),
                      ButtonSegment(
                        value: AppThemeMode.dark,
                        label: Text('theme.dark'.tr()),
                      ),
                    ],
                    selected: {
                      context.read<ThemeCubit>().currentThemeMode
                    },
                    onSelectionChanged: (Set<Object> newSelection) {
                      context.read<ThemeCubit>().changeTheme(
                          newSelection.first as AppThemeMode, context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    void showSettingsBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text('home.settings.history'.tr()),
                  onTap: () {
                    context.pushNamed('history');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.brightness_6),
                  title: Text('home.settings.theme'.tr()),
                  onTap: () {
                    showThemeChangeDialog(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text('home.settings.language'.tr()),
                  onTap: () {
                    if (context.locale == Locale('en')) {
                      context.setLocale(Locale('vi'));
                    } else {
                      context.setLocale(Locale('en'));
                    }
                  },
                  trailing: Text(context.locale.languageCode.toUpperCase()
                      .tr()),
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('home.settings.about'.tr()),
                  onTap: () {
                    context.pushNamed('about');
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => {
              showSettingsBottomSheet(context),
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => context.pushNamed('yes-no'),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: 220,
                decoration: BoxDecoration(
                  color: isDarkTheme ? AppColors.blue : AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'home.yes'.tr(),
                            style: TextStyle(
                              color: isDarkTheme
                                  ? AppColors.lightBlue
                                  : AppColors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'home.or'.tr(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'home.no'.tr(),
                            style: TextStyle(
                              color: isDarkTheme
                                  ? AppColors.lightBlue
                                  : AppColors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset(
                        "assets/icons/question_ico.svg",
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => context.pushNamed('wheel'),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: 220,
                decoration: BoxDecoration(
                  color: isDarkTheme ? AppColors.orange : AppColors.lightOrange,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'home.spin-wheel'.tr(),
                            style: TextStyle(
                              color: isDarkTheme
                                  ? AppColors.lightOrange
                                  : AppColors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset(
                        "assets/icons/spin_wheel_ico.svg",
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
