import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:petani_film_v2/screens/home_screen.dart';

final GoRouter mainRouter = GoRouter(
  initialLocation: '/home',
  routes: <GoRoute>[
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
  ],
);
