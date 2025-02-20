import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ptnzzn_random/constants/app_router.dart';
import 'package:ptnzzn_random/constants/app_theme.dart';
import 'package:ptnzzn_random/logic/storage/history_storage.dart';
import 'package:ptnzzn_random/logic/theme/theme_cubit.dart';
import 'package:ptnzzn_random/presentation/wheel/wheel_cubit.dart';
import 'package:ptnzzn_random/presentation/yes_no/yes_no_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final historyStorage = HistoryStorage();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => YesNoCubit(historyStorage),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => WheelCubit(historyStorage),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
          lazy: false,
        ),
        Provider<HistoryStorage>.value(
          value: historyStorage,
        ),
      ],
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
