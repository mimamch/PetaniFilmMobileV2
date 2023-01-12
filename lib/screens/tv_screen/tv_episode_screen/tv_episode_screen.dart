import 'package:flutter/material.dart';
import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/screens/components/movie_detail_section.dart';
import 'package:petani_film_v2/screens/components/movie_item.dart';
import 'package:petani_film_v2/services/movie_services.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';
import 'package:petani_film_v2/shared/widget/applovin_ads_widget.dart';
import 'package:petani_film_v2/shared/widget/custom_snackbar.dart';
import 'package:petani_film_v2/shared/widget/webview_iframe_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';

class TvEpisodeScreen extends StatefulWidget {
  const TvEpisodeScreen({super.key, required this.movie});
  final MovieItemModel movie;

  @override
  State<TvEpisodeScreen> createState() => _TvEpisodeScreenState();
}

class _TvEpisodeScreenState extends State<TvEpisodeScreen> {
  MovieItemModel? movieTemp;
  String? error;
  int currentServer = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Wakelock.enable();
      getData(widget.movie.url!);
      if (Constants.applovinInterstitialAdUnitId.isNotEmpty) {
        ApplovinAdsWidget().showInterstitialAds();
      }
    }
  }

  Future<MovieItemModel> getData(url) async {
    try {
      error = null;
      isLoading = true;
      if (widget.movie.url == null) throw 'Terjadi Kesalahan';
      MovieItemModel movieDetail = await MovieServices().getTvEpisode(url);
      movieDetail = widget.movie.copyWith(
        totalStreamingServer: movieDetail.totalStreamingServer,
        streamingLink: movieDetail.streamingLink,
        downloadLinks: movieDetail.downloadLinks,
      );
      movieTemp = movieDetail;
      isLoading = false;
      setState(() {});
      return movieDetail;
    } catch (e) {
      error = e.toString();
      isLoading = false;
      setState(() {});
      return MovieItemModel();
    }
  }

  void changeStreamServer(int player) {
    if (player == currentServer || isLoading) return;
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
        appBar: AppBar(
            title: Text(
                '[${widget.movie.currentEpisode ?? ''}] ${widget.movie.title ?? 'Tanpa Judul'}')),
        bottomNavigationBar:
            Constants.showAds && Constants.applovinBannerAdUnitId.isNotEmpty
                ? ApplovinAdsWidget().bannerAds
                : null,
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
                    changeStreamServer: changeStreamServer,
                    currentServer: currentServer,
                  ));
  }
}

class ShowData extends StatefulWidget {
  const ShowData(
      {super.key,
      required this.movie,
      required this.changeStreamServer,
      required this.currentServer});
  final MovieItemModel movie;
  final Function changeStreamServer;
  final int currentServer;

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
        widget.movie.streamingLink == null
            ? Container(
                color: Constants.blackColor,
                height: 200,
                child: Container(
                  color: Constants.blackColor,
                  height: 200,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : widget.movie.streamingLink!.isEmpty
                ? Container()
                : widget.currentServer == 0
                    ? Container(
                        color: Constants.greyColor,
                        height: 200,
                        child: const Center(
                            child: Text(
                          'Plih Server',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                      )
                    : error != null
                        ? Container(
                            color: Constants.blackColor,
                            height: 150,
                            child: Text(error!),
                          )
                        : WebViewModal(
                            streamingLink: widget.movie.streamingLink!,
                          ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          'Pilih Server Streaming',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        if (widget.movie.totalStreamingServer != null)
          Wrap(
              runSpacing: 5,
              children: List.generate(
                  widget.movie.totalStreamingServer!,
                  (index) => GestureDetector(
                        onTap: () {
                          widget.changeStreamServer(index + 1);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                              color: widget.currentServer == index + 1
                                  ? Constants.lightBlueColor
                                  : Constants.greyColor,
                              borderRadius: BorderRadius.circular(3)),
                          child: Text(
                            'Server ${index + 1}',
                          ),
                        ),
                      ))),
        const SizedBox(
          height: 10,
        ),
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
        ApplovinAdsWidget().mercAds,
        MovieDetailSection(movie: widget.movie),
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
