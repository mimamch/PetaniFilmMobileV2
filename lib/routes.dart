import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/screens/home_screen.dart';
import 'package:petani_film_v2/screens/movie_screen/movie_screen.dart';

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
    GoRoute(
      path: '/movie',
      name: 'movie',
      builder: (BuildContext context, GoRouterState state) {
        return MovieScreen(
          movie: state.extra! as MovieItemModel,
        );
      },
    ),
  ],
);
