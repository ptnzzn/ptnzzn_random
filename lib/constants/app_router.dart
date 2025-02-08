import 'package:go_router/go_router.dart';
import 'package:ptnzzn_random/presentation/home/home_screen.dart';
import 'package:ptnzzn_random/presentation/wheel/wheel_screen.dart';
import 'package:ptnzzn_random/presentation/yes_no/yes_no_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => HomeScreen(),
          routes: [
            GoRoute(
              path: 'yes-no',
              name: 'yes-no',
              builder: (context, state) => YesNoScreen(),
            ),
            GoRoute(
              path: 'wheel', 
              name: 'wheel', 
              builder: (context, state) => WheelScreen(),
            ),
          ]),
    ],
  );
}
