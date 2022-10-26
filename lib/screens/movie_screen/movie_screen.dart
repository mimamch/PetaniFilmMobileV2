import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
  @override
  void initState() {
    super.initState();
    if (mounted) {
      getData();
    }
  }

  Future<MovieItemModel> getData() async {
    try {
      if (widget.movie.url != null) {
        MovieItemModel movieDetail =
            await MovieServices().getMovieDetail(widget.movie.url!);
        movie = movieDetail;

        setState(() {});
        return movieDetail;
      }
      throw 'Tidak Ditemukan!';
    } catch (e) {
      rethrow;
    }
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
                : ShowData(movie: movie!));
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
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        // Container(
        //   color: Constants.greyColor,
        //   height: 150,
        // ),
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
    final iframe = '''
<iframe src="$streamingLink" width="100%" height="100%" frameborder="0" allowfullscreen></iframe>
''';

    final frm = Uri.dataFromString(
      iframe,
      mimeType: 'text/html',
    );
    return SizedBox(
      height: 200,
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: frm),
        onCreateWindow: (controller, createWindowAction) async => false,
        // initialOptions:
        //     InAppWebViewGroupOptions(crossPlatform: InAppWebViewOptions(

        //     )),
      ),
    );
  }
}
