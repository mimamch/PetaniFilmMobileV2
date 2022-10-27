import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/screens/components/movie_item.dart';
import 'package:petani_film_v2/services/movie_services.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';
import 'package:petani_film_v2/shared/widget/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key, required this.movie});
  final MovieItemModel movie;

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  MovieItemModel? movieTemp;
  String? error;
  int currentServer = 0;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      getData(widget.movie.url!);
    }
  }

  Future<MovieItemModel> getData(url) async {
    try {
      if (widget.movie.url != null) {
        MovieItemModel movieDetail = await MovieServices().getMovieDetail(url);
        movieTemp = movieDetail;
        setState(() {});
        return movieDetail;
      }
      throw 'Tidak Ditemukan!';
    } catch (e) {
      rethrow;
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
            : widget.currentServer == 0
                ? Container(
                    color: Constants.greyColor,
                    height: 200,
                    child: const Center(
                        child: Text(
                      'Plih Server',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          'Pilih Server',
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
        if (widget.movie.downloadLinks != null)
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
          height: 15,
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

class WebViewModal extends StatefulWidget {
  const WebViewModal({super.key, required this.streamingLink});
  final String streamingLink;

  @override
  State<WebViewModal> createState() => _WebViewModalState();
}

class _WebViewModalState extends State<WebViewModal> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      // child: InAppWebView(
      //   initialUrlRequest: URLRequest(url: frm),
      //   onCreateWindow: (controller, createWindowAction) async {
      //     print('WINDOW OPEN>>>>>>>>>>>>>>>>>>>>>>>');
      //   },
      //   // initialOptions:
      //   //     InAppWebViewGroupOptions(crossPlatform: InAppWebViewOptions(

      //   //     )),

      //   // onConsoleMessage: (controller, consoleMessage) =>
      //   //     print(consoleMessage.message),
      // ),
      child: IndexedStack(
        index: index,
        children: [
          Container(
            color: Constants.blackColor,
            height: 200,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          // WebViewX(
          //   width: double.infinity,
          //   height: 200,
          //   initialSourceType: SourceType.url,
          //   // initialContent: widget.streamingLink,
          //   initialContent: 'https://smm.mimamch.online',
          //   onPageFinished: (src) => setState(() {
          //     index = 1;
          //   }),
          //   onWebResourceError: (error) => setState(() {
          //     index = 2;
          //   }),
          //   navigationDelegate: (NavigationRequest navigation) {
          //     return NavigationDecision.prevent;
          //   },
          // ),
          InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(widget.streamingLink)),
            onCreateWindow: (controller, createWindowAction) async {
              return false;
            },
            onLoadStop: (controller, url) => setState(() {
              index = 1;
            }),
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              return NavigationActionPolicy.CANCEL;
            },
            initialOptions: InAppWebViewGroupOptions(
              android: AndroidInAppWebViewOptions(
                  // useHybridComposition: true,
                  ),
            ),
            onLoadError: (controller, url, code, message) => setState(() {
              index = 2;
            }),
          ),
          Container(
            color: Constants.greyColor,
            height: 200,
            child: const Center(
                child: Text(
              'Upsss... Terjadi Kesalahan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
          )
        ],
      ),
    );
  }
}
