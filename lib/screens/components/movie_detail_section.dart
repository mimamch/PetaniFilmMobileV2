import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';

class MovieDetailSection extends StatelessWidget {
  const MovieDetailSection({super.key, required this.movie});
  final MovieItemModel movie;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: Constants.whiteColor,
        ),
        const SizedBox(
          height: 8,
        ),
        const Text(
          'Genre',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Wrap(
            runSpacing: 5,
            children: (movie.genres ?? [])
                .map((e) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                          color: Constants.primaryblueColor,
                          borderRadius: BorderRadius.circular(3)),
                      child: Text(
                        e,
                      ),
                    ))
                .toList()),
        const SizedBox(
          height: 8,
        ),
        const Text(
          'Rating',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (movie.rating != null)
          RatingBar.builder(
            itemCount: 5,
            initialRating: movie.rating! / 2,
            itemSize: 20,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (value) {},
          ),
        const SizedBox(
          height: 8,
        ),
        const Text(
          'Tanggal Rilis',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(movie.releaseDate ?? '-'),
        const SizedBox(
          height: 8,
        ),
        if (movie.country != null) ...[
          const Text(
            'Negara',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(movie.country ?? '-'),
          const SizedBox(
            height: 8,
          ),
        ],
        if (movie.actors != null) ...[
          const Text(
            'Aktor',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Wrap(
              runSpacing: 5,
              children: (movie.actors ?? [])
                  .map((e) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                            color: Constants.purpleColor,
                            borderRadius: BorderRadius.circular(3)),
                        child: Text(
                          e,
                        ),
                      ))
                  .toList()),
          const SizedBox(
            height: 8,
          ),
        ],
        const Text(
          'Sinopsis',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(movie.description ?? '-'),
        const SizedBox(
          height: 15,
        ),
        const Divider(
          color: Constants.whiteColor,
        ),
      ],
    );
  }
}
