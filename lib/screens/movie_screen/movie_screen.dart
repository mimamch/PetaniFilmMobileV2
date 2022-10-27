import 'package:flutter/material.dart';
import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/screens/components/movie_item.dart';
import 'package:petani_film_v2/services/movie_services.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';
import 'package:webviewx/webviewx.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key, required this.movie});
  final MovieItemModel movie;

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  MovieItemModel? movie;
  String? error;
  int currentServer = 1;
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
        movie = movieDetail;
        setState(() {});
        return movieDetail;
      }
      throw 'Tidak Ditemukan!';
    } catch (e) {
      rethrow;
    }
  }

  void changeStreamServer(int player) {
    setState(() {
      movie = null;
      error = null;
      currentServer = player;
    });
    getData("${widget.movie.url ?? ''}?player=$player");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.movie.title ?? 'Tanpa Judul')),
        body: error == null && movie == null
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
                    movie: movie!,
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
                color: Constants.greyColor,
                height: 150,
                child: const Text('Tidak Tersedia'),
              )
            : error != null
                ? Container(
                    color: Constants.greyColor,
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

class WebViewModal extends StatelessWidget {
  const WebViewModal({super.key, required this.streamingLink});
  final String streamingLink;

  @override
  Widget build(BuildContext context) {
//     return WebViewX(
//       width: double.infinity,
//       height: 200,
//       initialContent: """
// <!doctype html>
// <html lang="en">
//     <head>
//         <meta charset="UTF-8">
//         <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
//         <meta http-equiv="X-UA-Compatible" content="ie=edge">
//         <title>Flutter InAppBrowser</title>
//     </head>
//     <body>
//         <iframe src="$streamingLink" width="100%" height="100%" frameborder="0" allowfullscreen></iframe>
//     </body>
// </html>""",
//       initialSourceType: SourceType.html,
//       // initialContent: widget.movie.streamingLink!,
//       // initialSourceType: SourceType.url,
//       // mobileSpecificParams: MobileSpecificParams(
//       //     debuggingEnabled: true, androidEnableHybridComposition: true),
//       javascriptMode: JavascriptMode.disabled,
//       onPageFinished: (src) => debugPrint(src),
//     );
//     final iframe = '''
// <html>
// <body>
// <iframe src="$streamingLink" width="100%" height="100%" frameborder="0" allowfullscreen></iframe>
// </body>
// </html>
// ''';

    // final frm = Uri.dataFromString(
    //   iframe,
    //   mimeType: 'text/html',
    // );

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
      child: WebViewX(
        width: double.infinity,
        height: 200,
        initialSourceType: SourceType.url,
        initialContent: streamingLink,
        navigationDelegate: (NavigationRequest navigation) {
          return NavigationDecision.prevent;
          // if (request.content.source) {
          //   print('blocking navigation to $request}');
          //   return NavigationDecision.prevent;
          // }
          // if (request.url.startsWith('https://flutter.dev/docs')) {
          //   print('blocking navigation to $request}');
          //   return NavigationDecision.prevent;
          // }
          // print('allowing navigation to $request');
          // return NavigationDecision.navigate;
        },
      ),
    );
  }
}
