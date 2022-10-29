import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';

class WebViewModal extends StatefulWidget {
  const WebViewModal({super.key, required this.streamingLink});
  final String streamingLink;

  @override
  State<WebViewModal> createState() => _WebViewModalState();
}

class _WebViewModalState extends State<WebViewModal> {
  int index = 0;
  bool isError = false;
  void setIndex(int n) {
    if (isError) {
      index = 1;
    } else {
      index = n;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
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
          Container(
            color: Constants.blackColor,
            height: 200,
            child: const Center(
                child: Text(
              'Upsss... Terjadi Kesalahan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
          ),
          InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(widget.streamingLink)),
            onLoadStop: (controller, url) => setIndex(2),
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              return NavigationActionPolicy.CANCEL;
            },
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                preferredContentMode: UserPreferredContentMode.MOBILE,
              ),
            ),
            onLoadError: (controller, url, code, message) {
              isError = true;
              setIndex(1);
            },
            onLoadHttpError: (controller, url, statusCode, description) {
              isError = true;
              setIndex(1);
            },
            onEnterFullscreen: (controller) =>
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.landscapeLeft]),
            onExitFullscreen: (controller) =>
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]),
          ),
        ],
      ),
    );
  }
}
