import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/screens/components/movie_item.dart';
import 'package:petani_film_v2/services/movie_services.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';
import 'package:petani_film_v2/shared/widget/applovin_ads_widget.dart';
import 'package:petani_film_v2/shared/widget/custom_snackbar.dart';
import 'package:petani_film_v2/shared/widget/webview_iframe_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';

class TvScreen extends StatefulWidget {
  const TvScreen({super.key, required this.movie});
  final MovieItemModel movie;

  @override
  State<TvScreen> createState() => _TvScreenState();
}

class _TvScreenState extends State<TvScreen> {
  MovieItemModel? movieTemp;
  String? error;
  int currentServer = 0;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Wakelock.enable();
      getData(widget.movie.url!);
    }
  }

  Future<MovieItemModel> getData(url) async {
    try {
      error = null;
      if (widget.movie.url == null) throw 'Terjadi Kesalahan';
      MovieItemModel movieDetail = await MovieServices().getTvDetail(url);
      movieDetail = movieDetail.copyWith(
          title: widget.movie.title, streamingLink: movieDetail.streamingLink);
      movieTemp = movieDetail;
      setState(() {});
      return movieDetail;
    } catch (e) {
      error = e.toString();
      setState(() {});
      return MovieItemModel();
    }
  }

  void changeStreamServer(int player) {
    if (player == currentServer) return;
    setState(() {
      movieTemp = movieTemp?.copyWith(streamingLink: null);
      error = null;
      currentServer = player;
    });
    getData("${widget.movie.url ?? ''}?player=$player");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.movie.title ?? 'Tanpa Judul')),
        bottomNavigationBar:
            Constants.showAds ? ApplovinAdsWidget().bannerAds : null,
        body: error == null && movieTemp == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : error != null
                ? Center(
                    child: Text(
                      error!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                : ShowData(
                    movie: movieTemp!,
                  ));
  }
}

class ShowData extends StatefulWidget {
  const ShowData({
    super.key,
    required this.movie,
  });
  final MovieItemModel movie;

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  String? error;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        if (widget.movie.streamingLink != null) ...[
          WebViewModal(streamingLink: widget.movie.streamingLink!),
          const SizedBox(
            height: 8,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
        if (widget.movie.streamingLink == null)
          Container(
            color: Constants.blackColor,
            height: 200,
            child: const Center(
                child: Text(
              'Tidak Ada Trailer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
          ),
        if (widget.movie.episodes != null &&
            widget.movie.episodes!.isNotEmpty) ...[
          const Text(
            'Pilih Episode',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Wrap(
              runSpacing: 5,
              children: widget.movie.episodes!
                  .map((e) => GestureDetector(
                        onTap: () {
                          MovieItemModel data = widget.movie.copyWith(
                              url: e['link'], currentEpisode: e['label']);
                          context.pushNamed('tv-episode', extra: data);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                              color: Constants.lightBlueColor,
                              borderRadius: BorderRadius.circular(3)),
                          child: Text(
                            e['label'] ?? 'Tidak Diketahui',
                          ),
                        ),
                      ))
                  .toList()),
          const SizedBox(
            height: 8,
          ),
        ],
        if (widget.movie.downloadLinks != null &&
            widget.movie.downloadLinks!.isNotEmpty) ...[
          const Text(
            'Download',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Wrap(
              runSpacing: 5,
              children: widget.movie.downloadLinks!
                  .map((e) => GestureDetector(
                        onTap: () async {
                          try {
                            if (e['link'] == null) throw Error();
                            // await launchUrlString(e['link'],
                            //     mode: LaunchMode.platformDefault);
                            await launchUrl(Uri.parse(e['link']),
                                mode: LaunchMode.externalApplication);
                          } catch (e) {
                            showCustomSnackbar(context, 'Gagal Membuka Link');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                              color: Constants.greenColor,
                              borderRadius: BorderRadius.circular(3)),
                          child: Text(
                            e['label'] ?? 'Tidak Diketahui',
                          ),
                        ),
                      ))
                  .toList()),
          const SizedBox(
            height: 8,
          ),
        ],
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
            children: (widget.movie.genres ?? [])
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
        if (widget.movie.rating != null)
          RatingBar.builder(
            itemCount: 5,
            initialRating: widget.movie.rating! / 2,
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
        Text(widget.movie.releaseDate ?? '-'),
        const SizedBox(
          height: 8,
        ),
        if (widget.movie.country != null) ...[
          const Text(
            'Negara',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(widget.movie.country ?? '-'),
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
        Text(widget.movie.description ?? '-'),
        const SizedBox(
          height: 15,
        ),
        const Divider(
          color: Constants.whiteColor,
        ),
        const Text(
          'Film Terkait',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              ...(widget.movie.relatedPost
                      ?.map((e) => Container(
                            margin: const EdgeInsets.only(right: 10),
                            height: 150,
                            child: HomeFeaturedItem(movie: e),
                          ))
                      .toList() ??
                  [])
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
