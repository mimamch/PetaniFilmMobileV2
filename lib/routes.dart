import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/screens/home_screen.dart';
import 'package:petani_film_v2/screens/movie_screen/movie_screen.dart';
import 'package:petani_film_v2/screens/tv_screen/tv_episode_screen/tv_episode_screen.dart';
import 'package:petani_film_v2/screens/tv_screen/tv_screen.dart';

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
        path: '/detail',
        name: 'detail',
        builder: (BuildContext context, GoRouterState state) {
          if ((state.extra as MovieItemModel).type == 'movie') {
            return MovieScreen(
              movie: state.extra! as MovieItemModel,
            );
          } else {
            return TvScreen(movie: state.extra as MovieItemModel);
          }
        },
        routes: <GoRoute>[
          GoRoute(
            path: 'tv-episode',
            name: 'tv-episode',
            builder: (BuildContext context, GoRouterState state) {
              return TvEpisodeScreen(movie: state.extra as MovieItemModel);
            },
          ),
        ]),
  ],
);
