import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ptnzzn_random/constants/app_router.dart';
import 'package:ptnzzn_random/constants/app_theme.dart';
import 'package:ptnzzn_random/logic/theme/theme_cubit.dart';
import 'package:ptnzzn_random/presentation/wheel/wheel_cubit.dart';
import 'package:ptnzzn_random/presentation/yes_no/yes_no_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('vi')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => YesNoCubit(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => WheelCubit(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
          lazy: false,
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            builder: (context, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<ThemeCubit>().updateSystemTheme();
              });
              return child!;
            },
          );
        },
      ),
    );
  }
}
