import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/screens/home_screen.dart';
import 'package:petani_film_v2/screens/movie_screen/movie_screen.dart';
import 'package:petani_film_v2/screens/search_screen/search_screen.dart';
import 'package:petani_film_v2/screens/tv_screen/tv_episode_screen/tv_episode_screen.dart';
import 'package:petani_film_v2/screens/tv_screen/tv_screen.dart';

final GoRouter mainRouter = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/search/:query',
      name: 'search',
      builder: (BuildContext context, GoRouterState state) {
        return SearchScreen(
          query: state.params['query'] ?? '',
        );
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
