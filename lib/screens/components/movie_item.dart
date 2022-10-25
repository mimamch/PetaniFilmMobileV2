import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';

class HomeMovieItem extends StatelessWidget {
  final MovieItemModel movie;
  const HomeMovieItem({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
                    fontSize: 13,
                    color: Constants.whiteColor,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
