import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';
import 'package:shimmer/shimmer.dart';

class HomeMovieItem extends StatelessWidget {
  final MovieItemModel movie;
  const HomeMovieItem({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (movie.type == 'movie') {
          context.pushNamed('movie', extra: movie);
        }
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: double.infinity,
              // height: double.infinity,
              color: Constants.greyColor,
              child: CachedNetworkImage(
                imageUrl: movie.posterUrl ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: AlignmentDirectional.topCenter,
                      end: AlignmentDirectional.bottomCenter,
                      stops: const [
                        0.0,
                        0.3,
                      ],
                      colors: [
                        Constants.blackColor.withOpacity(0.0),
                        Constants.blackColor.withOpacity(0.6)
                      ]),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Text(
                  movie.title ?? '',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Constants.whiteColor,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
          ),
          if (movie.type == 'tv')
            Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: const BoxDecoration(
                      color: Constants.lightBlueColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                      )),
                  child: const Text(
                    'TV',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                )),
          if (movie.quality != null)
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: const BoxDecoration(
                    color: Constants.greenColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                    )),
                child: Text(
                  movie.quality ?? '-',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class HomeMovieItemShimmer extends StatelessWidget {
  const HomeMovieItemShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 163, 163, 163),
      highlightColor: const Color.fromRGBO(245, 245, 245, 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          height: 100,
          color: Constants.greyColor,
        ),
      ),
    );
  }
}

class HomeFeaturedItem extends StatelessWidget {
  final MovieItemModel movie;
  const HomeFeaturedItem({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (movie.type == 'movie') {
          if (context.canPop()) {
            context.pop();
            context.pushNamed('movie', extra: movie);
          } else {
            context.pushNamed('movie', extra: movie);
          }
        }
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              // width: double.infinity,
              height: double.infinity,
              color: Constants.greyColor,
              child: CachedNetworkImage(
                imageUrl: movie.posterUrl ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: AlignmentDirectional.topCenter,
                      end: AlignmentDirectional.bottomCenter,
                      stops: const [
                        0.0,
                        0.3,
                      ],
                      colors: [
                        Constants.blackColor.withOpacity(0.0),
                        Constants.blackColor.withOpacity(0.6)
                      ]),
                  // color: Constants.kBlackColor.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Text(
                  movie.title ?? '',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Constants.whiteColor,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
          ),
          if (movie.type == 'tv')
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: const BoxDecoration(
                    color: Constants.lightBlueColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                    )),
                child: const Text(
                  'TV',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ),
          if (movie.quality != null)
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: const BoxDecoration(
                    color: Constants.greenColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                    )),
                child: Text(
                  movie.quality ?? '-',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
