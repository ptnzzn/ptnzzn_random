import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ptnzzn_random/constants/app_color.dart';
import 'package:ptnzzn_random/constants/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => {},
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
                              'Yes',
                              style: TextStyle(
                                  color: isDarkTheme ? AppColors.lightBlue : AppColors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Text(
                              ' or ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'No',
                              style: TextStyle(
                                  color: isDarkTheme ? AppColors.lightBlue : AppColors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
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
                  )),
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
                              'Fortune spin wheel',
                              style: TextStyle(
                                  color: isDarkTheme ? AppColors.lightOrange : AppColors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )
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
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
